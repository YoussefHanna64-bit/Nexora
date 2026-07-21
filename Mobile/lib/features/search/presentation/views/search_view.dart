import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexora/core/widgets/custom_error_widget.dart';
import 'package:nexora/features/product/presentation/manager/product/product_cubit.dart';
import 'package:nexora/features/product/presentation/manager/product/product_state.dart';
import 'package:nexora/features/search/presentation/widgets/search_app_bar.dart';
import 'package:nexora/features/search/presentation/widgets/search_results_sliver.dart';

class SearchView extends StatefulWidget {
  final String? initialSearchQuery;
  final Map<String, dynamic>? initialFilters;

  const SearchView({super.key, this.initialSearchQuery, this.initialFilters});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late TextEditingController _searchController;
  late ScrollController _scrollController;

  Map<String, dynamic> _activeFilters = {};
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController =
        TextEditingController(text: widget.initialSearchQuery ?? "");

    if (widget.initialFilters != null) {
      _activeFilters = Map.from(widget.initialFilters!);
    }

    _scrollController = ScrollController()..addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) => _search());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final max = _scrollController.position.maxScrollExtent;

    if (_scrollController.offset >= max * 0.8) {
      final state = context.read<ProductCubit>().state;
      if (state is ProductPaginatedState &&
          !state.isLoadingMore &&
          !state.isReachedMax) {
        context.read<ProductCubit>().fetchMoreProducts();
      }
    }
  }

  void _search({Map<String, dynamic>? overrideFilters}) {
    final filters = overrideFilters ?? _activeFilters;
    final params = Map<String, dynamic>.from(filters);

    if (_searchController.text.trim().isNotEmpty) {
      params["keyword"] = _searchController.text.trim();
    }

    context.read<ProductCubit>().fetchProductsPaginated(filters: params);
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), _search);
  }

  void _onFiltersApplied(Map<String, dynamic> filters) {
    setState(() {
      _activeFilters = filters;
    });

    _search(overrideFilters: {
      ...filters,
      if (_searchController.text.trim().isNotEmpty)
        "keyword": _searchController.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: SearchAppBar(
        searchController: _searchController,
        activeFilters: _activeFilters,
        onSearchChanged: _onSearchChanged,
        onFiltersApplied: _onFiltersApplied,
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: _search,
            );
          }

          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SearchResultsSliver(
                state: state,
                horizontalPadding: w * 0.04,
                verticalPadding: h * 0.02,
              ),
            ],
          );
        },
      ),
    );
  }
}
