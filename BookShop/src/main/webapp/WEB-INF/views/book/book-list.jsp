<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<fmt:setLocale value="vi_VN" />

<%@ include file="/WEB-INF/views/base/header.jsp"%>

<div class="page-content bg-grey">
	<div class="content-inner-1 border-bottom">
		<div class="container">
			<div class="row">

				<div class="col-xl-3">
					<form id="filterForm"
						action="${pageContext.request.contextPath}/books" method="get">
						<input type="hidden" name="keyword" value="${keyword}"> <input
							type="hidden" name="minPrice" id="minPriceInput"> <input
							type="hidden" name="maxPrice" id="maxPriceInput"> <input
							type="hidden" name="sort" id="sortInput" value="${param.sort}">

						<div class="shop-filter"
							style="position: sticky; top: 100px; z-index: 10; max-height: calc(100vh - 110px);">
							<div class="d-flex justify-content-between">
								<h4 class="title">Lựa chọn lọc</h4>
								<a href="javascript:void(0);" class="panel-close-btn"> <i
									class="flaticon-close"></i>
								</a>
							</div>

							<div class="accordion accordion-filter" id="accordionExample">

								<div class="accordion-item">
									<button class="accordion-button" id="headingFive" type="button"
										data-bs-toggle="collapse" data-bs-target="#collapseFive"
										aria-expanded="false" aria-controls="collapseFive">
										Mức giá</button>
									<div id="collapseFive"
										class="accordion-collapse collapse accordion-body show"
										aria-labelledby="headingFive"
										data-bs-parent="#accordionExample">
										<div class="range-slider style-1">
											<div class="d-flex align-items-center gap-2 mb-3 mt-2">
												<div class="flex-fill">
													<label class="form-label small text-muted mb-1">Từ
														(₫)</label> <input type="number" id="manualMin"
														class="form-control form-control-sm" placeholder="0"
														style="min-width: 90px;"
														value="${minPrice != null && minPrice > 0 ? minPrice.intValue() : ''}">
												</div>
												<span class="mt-3">—</span>
												<div class="flex-fill">
													<label class="form-label small text-muted mb-1">Đến
														(₫)</label> <input type="number" id="manualMax"
														class="form-control form-control-sm"
														placeholder="${dbMaxPrice.intValue()}" style="min-width: 100px;"
														value="${maxPrice != null && maxPrice < dbMaxPrice ? maxPrice.intValue() : ''}">
												</div>
											</div>

											<div id="slider-tooltips"></div>
										</div>
									</div>
								</div>

								<div class="accordion-item">
									<button class="accordion-button" id="headingOne" type="button"
										data-bs-toggle="collapse" data-bs-target="#collapseOne"
										aria-expanded="true" aria-controls="collapseOne">
										Chọn danh mục</button>
									<div id="collapseOne"
										class="accordion-collapse collapse show accordion-body"
										aria-labelledby="headingOne"
										data-bs-parent="#accordionExample">
										<div
											class="widget dz-widget_services d-flex justify-content-between">
											<div>
												<c:forEach var="cat" items="${categories}"
													varStatus="status">
													<c:if test="${status.index % 2 == 0}">
														<div class="form-check search-content">
															<input class="form-check-input" type="checkbox"
																name="categoryId" value="${cat.id}"
																id="sidebar-cat${cat.id}"
																<c:set var="isChecked" value="false"/><c:forEach var="selectedId" items="${paramValues.categoryId}">
           <c:if test="${selectedId == cat.id}">
               <c:set var="isChecked" value="true"/>
           </c:if>
       </c:forEach>
       ${isChecked ? 'checked' : ''}>
															<label class="form-check-label"
																for="sidebar-cat${cat.id}"> ${cat.name} </label>
														</div>
													</c:if>
												</c:forEach>
											</div>

											<div>
												<c:forEach var="cat" items="${categories}"
													varStatus="status">
													<c:if test="${status.index % 2 != 0}">
														<div class="form-check search-content">
															<input class="form-check-input" type="checkbox"
																name="categoryId" value="${cat.id}"
																id="sidebar-cat${cat.id}"
																<c:forEach var="selectedId" items="${paramValues.categoryId}">
																   <c:if test="${selectedId == cat.id}">checked</c:if>
															</c:forEach>>
															<label class="form-check-label"
																for="sidebar-cat${cat.id}"> ${cat.name} </label>
														</div>
													</c:if>
												</c:forEach>
											</div>
										</div>
									</div>
								</div>



								<%-- Nhà xuất bản --%>
								<c:if test="${not empty distinctPublishers}">
									<div class="accordion-item">
										<button class="accordion-button collapsed" type="button"
											data-bs-toggle="collapse" data-bs-target="#collapsePublisher"
											aria-expanded="false">Nhà xuất bản</button>
										<div id="collapsePublisher"
											class="accordion-collapse collapse accordion-body">
											<div class="widget dz-widget_services">
												<c:forEach var="pub" items="${distinctPublishers}">
													<div class="form-check search-content">
														<input class="form-check-input filter-checkbox"
															type="checkbox" name="publisher" value="${pub}"
															id="pub-${pub}"
															<c:forEach var="s" items="${selectedPublishers}">
                            <c:if test="${s == pub}">checked</c:if>
                        </c:forEach>>
														<label class="form-check-label" for="pub-${pub}">${pub}</label>
													</div>
												</c:forEach>
											</div>
										</div>
									</div>
								</c:if>

								<%-- Năm xuất bản --%>
								<c:if test="${not empty distinctYears}">
									<div class="accordion-item">
										<button class="accordion-button collapsed" type="button"
											data-bs-toggle="collapse" data-bs-target="#collapseYear"
											aria-expanded="false">Năm xuất bản</button>
										<div id="collapseYear"
											class="accordion-collapse collapse accordion-body">
											<div
												class="widget dz-widget_services d-flex flex-wrap justify-content-between">
												<c:forEach var="yr" items="${distinctYears}">
													<div class="form-check search-content"
														style="min-width: 80px;">
														<input class="form-check-input filter-checkbox"
															type="checkbox" name="publishYear" value="${yr}"
															id="yr-${yr}"
															<c:forEach var="s" items="${selectedYears}">
                            <c:if test="${s == yr}">checked</c:if>
                        </c:forEach>>
														<label class="form-check-label" for="yr-${yr}">${yr}</label>
													</div>
												</c:forEach>
											</div>
										</div>
									</div>
								</c:if>

								<%-- Tác giả --%>
								<c:if test="${not empty authors}">
									<div class="accordion-item">
										<button class="accordion-button collapsed" type="button"
											data-bs-toggle="collapse" data-bs-target="#collapseAuthor"
											aria-expanded="false">Tác giả</button>
										<div id="collapseAuthor"
											class="accordion-collapse collapse accordion-body">
											<div class="widget dz-widget_services"
												style="max-height: 200px; overflow-y: auto;">
												<c:forEach var="auth" items="${authors}">
													<div class="form-check search-content">
														<input class="form-check-input filter-checkbox"
															type="checkbox" name="authorId" value="${auth.id}"
															id="auth-${auth.id}"
															<c:forEach var="s" items="${selectedAuthorIds}">
                            <c:if test="${s == auth.id}">checked</c:if>
                        </c:forEach>>
														<label class="form-check-label" for="auth-${auth.id}">${auth.name}</label>
													</div>
												</c:forEach>
											</div>
										</div>
									</div>
								</c:if>

								<div class="accordion accordion-inner" id="filter-inner">
									<div class="accordion-item">
										<button class="accordion-button" id="headingOne_inner"
											type="button" data-bs-toggle="collapse"
											data-bs-target="#collapseOne_inner" aria-expanded="true"
											aria-controls="collapseOne_inner">Best Sales (105)</button>
										<div id="collapseOne_inner"
											class="accordion-collapse collapse show accordion-body"
											aria-labelledby="headingOne_inner"
											data-bs-parent="#filter-inner">
											<ul>
												<li><a href="javascript:void(0);">Alone Here</a></li>
												<li><a href="javascript:void(0);">Alien Invassion</a></li>
												<li><a href="javascript:void(0);">Bullo The Cat</a></li>
												<li><a href="javascript:void(0);">Cut That Hair!</a></li>
												<li><a href="javascript:void(0);">Dragon Of The
														King</a></li>
											</ul>
										</div>
									</div>



									<div class="accordion-item">
										<button class="accordion-button collapsed"
											id="headingThree_inner" type="button"
											data-bs-toggle="collapse"
											data-bs-target="#collapseThree_inner" aria-expanded="false"
											aria-controls="collapseThree_inner">Newest Books
											(32)</button>
										<div id="collapseThree_inner"
											class="accordion-collapse collapse accordion-body"
											aria-labelledby="headingThree_inner"
											data-bs-parent="#filter-inner">
											<ul>
												<li><a href="javascript:void(0);">Alone Here</a></li>
												<li><a href="javascript:void(0);">Alien Invassion</a></li>
												<li><a href="javascript:void(0);">Bullo The Cat</a></li>
												<li><a href="javascript:void(0);">Cut That Hair!</a></li>
												<li><a href="javascript:void(0);">Dragon Of The
														King</a></li>
											</ul>
										</div>
									</div>



									<div class="accordion-item">
										<button class="accordion-button collapsed"
											id="headingFive_inner" type="button"
											data-bs-toggle="collapse"
											data-bs-target="#collapseFive_inner" aria-expanded="false"
											aria-controls="collapseFive_inner">Watch History
											(21)</button>
										<div id="collapseFive_inner"
											class="accordion-collapse collapse accordion-body"
											aria-labelledby="headingFive_inner"
											data-bs-parent="#filter-inner">
											<ul>
												<li><a href="javascript:void(0);">Alone Here</a></li>
												<li><a href="javascript:void(0);">Alien Invassion</a></li>
												<li><a href="javascript:void(0);">Bullo The Cat</a></li>
												<li><a href="javascript:void(0);">Cut That Hair!</a></li>
												<li><a href="javascript:void(0);">Dragon Of The
														King</a></li>
											</ul>
										</div>
									</div>

									<div class="accordion-item">
										<button class="accordion-button collapsed"
											id="headingSix_inner" type="button" data-bs-toggle="collapse"
											data-bs-target="#collapseSix_inner" aria-expanded="false"
											aria-controls="collapseSix_inner">Best Books (44)</button>
										<div id="collapseSix_inner"
											class="accordion-collapse collapse accordion-body"
											aria-labelledby="headingSix_inner"
											data-bs-parent="#filter-inner">
											<ul>
												<li><a href="javascript:void(0);">Alone Here</a></li>
												<li><a href="javascript:void(0);">Alien Invassion</a></li>
												<li><a href="javascript:void(0);">Bullo The Cat</a></li>
												<li><a href="javascript:void(0);">Cut That Hair!</a></li>
												<li><a href="javascript:void(0);">Dragon Of The
														King</a></li>
											</ul>
										</div>
									</div>
								</div>
							</div>

							<div class="row filter-buttons">
								<div>
									<button type="submit"
										class="btn btn-secondary btnhover mt-4 d-block w-100">
										Refine Search</button>
									<a href="${pageContext.request.contextPath}/books"
										class="btn btn-outline-secondary btnhover mt-3 d-block">
										Reset Filter </a>
								</div>
							</div>
						</div>
					</form>
				</div>

				<div class="col-xl-9">
					<div class="d-flex justify-content-between align-items-center">
						<h4 class="title">Sách</h4>
						<a href="javascript:void(0);" class="btn btn-primary panel-btn">Filter</a>
					</div>

					<div class="filter-area m-b30">
						<div class="grid-area">
							<div class="shop-tab">
								<ul class="nav text-center product-filter justify-content-end"
									role="tablist">
									<li class="nav-item"><a class="nav-link"
										href="books-list.html"> <svg width="24" height="24"
												viewBox="0 0 24 24" fill="none"
												xmlns="http://www.w3.org/2000/svg">
												<path
													d="M3 5H21C21.2652 5 21.5196 4.89464 21.7071 4.7071C21.8946 4.51957 22 4.26521 22 4C22 3.73478 21.8946 3.48043 21.7071 3.29289C21.5196 3.10536 21.2652 3 21 3H3C2.73478 3 2.48043 3.10536 2.29289 3.29289C2.10536 3.48043 2 3.73478 2 4C2 4.26521 2.10536 4.51957 2.29289 4.7071C2.48043 4.89464 2.73478 5 3 5Z"
													fill="#AAAAAA"></path>
												<path
													d="M3 13H21C21.2652 13 21.5196 12.8947 21.7071 12.7071C21.8946 12.5196 22 12.2652 22 12C22 11.7348 21.8946 11.4804 21.7071 11.2929C21.5196 11.1054 21.2652 11 21 11H3C2.73478 11 2.48043 11.1054 2.29289 11.2929C2.10536 11.4804 2 11.7348 2 12C2 12.2652 2.10536 12.5196 2.29289 12.7071C2.48043 12.8947 2.73478 13 3 13Z"
													fill="#AAAAAA"></path>
												<path
													d="M3 21H21C21.2652 21 21.5196 20.8947 21.7071 20.7071C21.8946 20.5196 22 20.2652 22 20C22 19.7348 21.8946 19.4804 21.7071 19.2929C21.5196 19.1054 21.2652 19 21 19H3C2.73478 19 2.48043 19.1054 2.29289 19.2929C2.10536 19.4804 2 19.7348 2 20C2 20.2652 2.10536 20.5196 2.29289 20.7071C2.48043 20.8947 2.73478 21 3 21Z"
													fill="#AAAAAA"></path>
											</svg>
									</a></li>
									<li class="nav-item"><a class="nav-link"
										href="books-grid-view.html"> <svg width="24" height="24"
												viewBox="0 0 24 24" fill="none"
												xmlns="http://www.w3.org/2000/svg">
												<path
													d="M3 11H10C10.2652 11 10.5196 10.8946 10.7071 10.7071C10.8946 10.5196 11 10.2652 11 10V3C11 2.73478 10.8946 2.48043 10.7071 2.29289C10.5196 2.10536 10.2652 2 10 2H3C2.73478 2 2.48043 2.10536 2.29289 2.29289C2.10536 2.48043 2 2.73478 2 3V10C2 10.2652 2.10536 10.5196 2.29289 10.7071C2.48043 10.8946 2.73478 11 3 11ZM4 4H9V9H4V4Z"
													fill="#AAAAAA"></path>
												<path
													d="M14 11H21C21.2652 11 21.5196 10.8946 21.7071 10.7071C21.8946 10.5196 22 10.2652 22 10V3C22 2.73478 21.8946 2.48043 21.7071 2.29289C21.5196 2.10536 21.2652 2 21 2H14C13.7348 2 13.4804 2.10536 13.2929 2.29289C13.1054 2.48043 13 2.73478 13 3V10C13 10.2652 13.1054 10.5196 13.2929 10.7071C13.4804 10.8946 13.7348 11 14 11ZM15 4H20V9H15V4Z"
													fill="#AAAAAA"></path>
												<path
													d="M3 22H10C10.2652 22 10.5196 21.8946 10.7071 21.7071C10.8946 21.5196 11 21.2652 11 21V14C11 13.7348 10.8946 13.4804 10.7071 13.2929C10.5196 13.1054 10.2652 13 10 13H3C2.73478 13 2.48043 13.1054 2.29289 13.2929C2.10536 13.4804 2 13.7348 2 14V21C2 21.2652 2.10536 21.5196 2.29289 21.7071C2.48043 21.8946 2.73478 22 3 22ZM4 15H9V20H4V15Z"
													fill="#AAAAAA"></path>
												<path
													d="M14 22H21C21.2652 22 21.5196 21.8946 21.7071 21.7071C21.8946 21.5196 22 21.2652 22 21V14C22 13.7348 21.8946 13.4804 21.7071 13.2929C21.5196 13.1054 21.2652 13 21 13H14C13.7348 13 13.4804 13.1054 13.2929 13.2929C13.1054 13.48043 13 13.73478 13 14V21C13 21.2652 13.1054 21.5196 13.2929 21.7071C13.4804 21.8946 13.7348 22 14 22ZM15 15H20V20H15V15Z"
													fill="#AAAAAA"></path>
											</svg>
									</a></li>
									<li class="nav-item"><a class="nav-link"
										href="books-grid-view-sidebar.html"> <svg width="24"
												height="24" viewBox="0 0 24 24" fill="none"
												xmlns="http://www.w3.org/2000/svg">
												<path
													d="M3 22H21C21.2652 22 21.5196 21.8946 21.7071 21.7071C21.8946 21.5196 22 21.2652 22 21V3C22 2.73478 21.8946 2.48043 21.7071 2.29289C21.5196 2.10536 21.2652 2 21 2H3C2.73478 2 2.48043 2.10536 2.29289 2.29289C2.10536 2.48043 2 2.73478 2 3V21C2 21.2652 2.10536 21.5196 2.29289 21.7071C2.48043 21.8946 2.73478 22 3 22ZM13 4H20V11H13V4ZM13 13H20V20H13V13ZM4 4H11V20H4V4Z"
													fill="#AAAAAA"></path>
											</svg>
									</a></li>
								</ul>
							</div>
						</div>

						<div class="category">
							<div class="form-group">
								<i class="fas fa-sort-amount-down me-2 text-secondary"></i>
								<div class="dropdown bootstrap-select default-select dropup">
									<button type="button" tabindex="-1"
										class="btn dropdown-toggle btn-light"
										data-bs-toggle="dropdown" role="combobox"
										aria-owns="bs-select-2" aria-haspopup="listbox"
										aria-expanded="false" title="Newest">
										<div class="filter-option">
											<div class="filter-option-inner">
												<div class="filter-option-inner-inner">Sắp xếp</div>
											</div>
										</div>
									</button>

									<div class="dropdown-menu"
										style="max-height: 285.2px; overflow: hidden; min-height: 112px;">
										<div class="inner show" role="listbox" id="bs-select-2"
											tabindex="-1" aria-activedescendant="bs-select-2-0"
											style="max-height: 269.2px; overflow-y: auto; min-height: 96px;">
											<ul class="dropdown-menu inner show" role="presentation"
												style="margin-top: 0; margin-bottom: 0;">
												<li class="selected active"><a role="option"
													class="dropdown-item active selected" id="bs-select-2-0"
													tabindex="0"> <span class="text">Nổi bật</span>
												</a></li>
												<li><a role="option" class="dropdown-item"
													id="bs-select-2-1" tabindex="0"><span class="text">Nổi
															bật</span></a></li>
												<li><a role="option" class="dropdown-item"
													id="bs-select-2-2" tabindex="0"><span class="text">Tên:
															A → Z</span></a></li>
												<li><a role="option" class="dropdown-item"
													id="bs-select-2-3" tabindex="0"><span class="text">Tên:
															Z → A</span></a></li>
												<li><a role="option" class="dropdown-item"
													id="bs-select-2-4" tabindex="0"><span class="text">Giá:
															Thấp → Cao</span></a></li>
												<li><a role="option" class="dropdown-item"
													id="bs-select-2-5" tabindex="0"><span class="text">Giá:
															Cao → Thấp</span></a></li>
											</ul>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="filter-tags m-b20"
							style="display: flex; flex-wrap: wrap; gap: 8px;">

							<c:if test="${not empty param.keyword}">
								<span
									style="display: inline-flex; align-items: center; gap: 6px; background: #f0f4ff; border: 1px solid #c7d7f5; color: #2d4fa0; border-radius: 20px; padding: 4px 12px; font-size: 13px;">
									Từ khóa: <strong>${param.keyword}</strong> <a
									href="javascript:void(0);" onclick="removeFilter('keyword','')"
									style="color: #2d4fa0; font-weight: bold; text-decoration: none;">×</a>
								</span>
							</c:if>

							<c:if
								test="${(minPrice != null && minPrice > 0) || (maxPrice != null && maxPrice < dbMaxPrice)}">
								<span
									style="display: inline-flex; align-items: center; gap: 6px; background: #f0f4ff; border: 1px solid #c7d7f5; color: #2d4fa0; border-radius: 20px; padding: 4px 12px; font-size: 13px;">
									Giá: <strong><fmt:formatNumber value="${minPrice}"
											pattern="#,###" />₫ — <fmt:formatNumber value="${maxPrice}"
											pattern="#,###" />₫</strong> <a href="javascript:void(0);"
									onclick="removeFilter('price','')"
									style="color: #2d4fa0; font-weight: bold; text-decoration: none;">×</a>
								</span>
							</c:if>

							<c:forEach var="catId" items="${paramValues.categoryId}">
								<c:forEach var="c" items="${categories}">
									<c:if test="${c.id == catId}">
										<span
											style="display: inline-flex; align-items: center; gap: 6px; background: #f0f4ff; border: 1px solid #c7d7f5; color: #2d4fa0; border-radius: 20px; padding: 4px 12px; font-size: 13px;">
											Danh mục: <strong>${c.name}</strong> <a
											href="javascript:void(0);"
											onclick="removeFilter('categoryId','${catId}')"
											style="color: #2d4fa0; font-weight: bold; text-decoration: none;">×</a>
										</span>
									</c:if>
								</c:forEach>
							</c:forEach>

							<c:forEach var="yr" items="${selectedYears}">
								<span
									style="display: inline-flex; align-items: center; gap: 6px; background: #f0f4ff; border: 1px solid #c7d7f5; color: #2d4fa0; border-radius: 20px; padding: 4px 12px; font-size: 13px;">
									Năm: <strong>${yr}</strong> <a href="javascript:void(0);"
									onclick="removeFilter('publishYear','${yr}')"
									style="color: #2d4fa0; font-weight: bold; text-decoration: none;">×</a>
								</span>
							</c:forEach>

							<c:forEach var="aId" items="${selectedAuthorIds}">
								<c:forEach var="auth" items="${authors}">
									<c:if test="${auth.id == aId}">
										<span
											style="display: inline-flex; align-items: center; gap: 6px; background: #f0f4ff; border: 1px solid #c7d7f5; color: #2d4fa0; border-radius: 20px; padding: 4px 12px; font-size: 13px;">
											Tác giả: <strong>${auth.name}</strong> <a
											href="javascript:void(0);"
											onclick="removeFilter('authorId','${aId}')"
											style="color: #2d4fa0; font-weight: bold; text-decoration: none;">×</a>
										</span>
									</c:if>
								</c:forEach>
							</c:forEach>

							<c:forEach var="pub" items="${selectedPublishers}">
								<span
									style="display: inline-flex; align-items: center; gap: 6px; background: #f0f4ff; border: 1px solid #c7d7f5; color: #2d4fa0; border-radius: 20px; padding: 4px 12px; font-size: 13px;">
									NXB: <strong>${pub}</strong> <a href="javascript:void(0);"
									onclick="removeFilter('publisher','${pub}')"
									style="color: #2d4fa0; font-weight: bold; text-decoration: none;">×</a>
								</span>
							</c:forEach>

						</div>
					</div>


					<div class="row book-grid-row">
						<c:if test="${empty books}">
							<div class="col-12 text-center p-5">

								<h3 class="mt-4">Rất tiếc, không tìm thấy sách phù hợp!</h3>
								<p>Bạn hãy thử thay đổi từ khóa tìm kiếm hoặc dùng ít bộ lọc
									hơn nhé.</p>
								<a href="${pageContext.request.contextPath}/books"
									class="btn btn-primary">Xóa tất cả bộ lọc</a>
							</div>
						</c:if>
						<c:forEach var="b" items="${books}">
							<div class="col-book style-2">
								<div class="dz-shop-card style-1">
									<div class="dz-media" style="position: relative;">
										<a
											href="${pageContext.request.contextPath}/books/${b.slug}-${b.id}">
											<img
											src="${not empty b.image ? b.image : pageContext.request.contextPath.concat('/assets/images/books/default-book.png')}"
											alt="${b.title}">
										</a>
										<c:if test="${b.originPrice > 0 && b.originPrice > b.price}">
											<span
												style="position: absolute; top: 10px; left: 10px; background: #e53935; color: #fff; font-size: 12px; font-weight: 700; padding: 3px 8px; border-radius: 4px; z-index: 2;">
												-<fmt:formatNumber
													value="${(1 - b.price/b.originPrice)*100}"
													maxFractionDigits="0" />%
											</span>
										</c:if>
									</div>

									<div class="bookmark-btn style-2">
										<input class="form-check-input" type="checkbox"
											id="fav-${b.id}"> <label class="form-check-label"
											for="fav-${b.id}"> <i class="flaticon-heart"></i>
										</label>
									</div>

									<div class="dz-content">
										<h5 class="title">
											<a
												href="${pageContext.request.contextPath}/books/${b.slug}-${b.id}">
												${b.title} </a>
										</h5>

										<ul class="dz-tags">
											<li><a
												href="${pageContext.request.contextPath}/books?categoryId=${b.category.id}">
													<c:out value="${b.category.name}" default="Chưa phân loại" />
											</a></li>
										</ul>

										<ul class="dz-rating">
											<c:forEach begin="1" end="5" var="star">
												<li><i
													class="flaticon-star ${star <= b.avgRating ? 'text-yellow' : 'text-muted'}"></i></li>
											</c:forEach>
										</ul>

										<div class="book-footer">
											<div class="price"">

												<span class="price-num"> <fmt:formatNumber
														value="${b.price}" pattern="#,###" /> &#8363;
												</span>
												<c:if test="${b.originPrice > 0 && b.originPrice > b.price}">
													<del>
														<fmt:formatNumber value="${b.originPrice}" pattern="#,###" />
														&#8363;
													</del>
												</c:if>
											</div>

											<button type="button"
												class="btn btn-secondary box-btn btnhover btnhover2 add-to-cart-btn"
												data-id="${b.id}">
												<i class="flaticon-shopping-cart-1 m-r10"></i> Add To Cart
											</button>
										</div>
									</div>
								</div>
							</div>
						</c:forEach>
					</div>

					<div class="row page mt-0">
						<div class="col-md-6">
							<p class="page-text">Hiển thị ${books.size()} / ${totalBooks}
								sách</p>
						</div>
						<div class="col-md-6">
							<nav aria-label="Blog Pagination">
								<ul class="pagination style-1 p-t20">
									<%-- Prev --%>
									<li class="page-item ${currentPage == 1 ? 'disabled' : ''}"><a
										class="page-link prev"
										href="${pageContext.request.contextPath}/books?page=${currentPage - 1}&keyword=${param.keyword}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}&sort=${param.sort}<c:forEach var='id' items='${paramValues.categoryId}'>&categoryId=${id}</c:forEach><c:forEach var='yr' items='${paramValues.publishYear}'>&publishYear=${yr}</c:forEach><c:forEach var='aId' items='${paramValues.authorId}'>&authorId=${aId}</c:forEach><c:forEach var='pub' items='${paramValues.publisher}'>&publisher=${pub}</c:forEach>">&#10094;</a></li>
									<%-- Trang 1 luôn hiện --%>
									<li class="page-item"><a
										class="page-link ${currentPage == 1 ? 'active' : ''}"
										href="${pageContext.request.contextPath}/books?page=1&keyword=${param.keyword}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}&sort=${param.sort}<c:forEach var='id' items='${paramValues.categoryId}'>&categoryId=${id}</c:forEach><c:forEach var='yr' items='${paramValues.publishYear}'>&publishYear=${yr}</c:forEach><c:forEach var='aId' items='${paramValues.authorId}'>&authorId=${aId}</c:forEach><c:forEach var='pub' items='${paramValues.publisher}'>&publisher=${pub}</c:forEach>">1</a>
									</li>

									<%-- Dấu ... đầu nếu currentPage > 3 --%>
									<c:if test="${currentPage > 3}">
										<li class="page-item disabled"><a class="page-link">...</a></li>
									</c:if>

									<%-- Các trang xung quanh currentPage --%>
									<c:forEach begin="2" end="${totalPages - 1}" var="i">
										<c:if test="${i >= currentPage - 1 && i <= currentPage + 1}">
											<li class="page-item"><a
												class="page-link ${i == currentPage ? 'active' : ''}"
												href="${pageContext.request.contextPath}/books?page=${i}&keyword=${param.keyword}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}&sort=${param.sort}<c:forEach var='id' items='${paramValues.categoryId}'>&categoryId=${id}</c:forEach><c:forEach var='yr' items='${paramValues.publishYear}'>&publishYear=${yr}</c:forEach><c:forEach var='aId' items='${paramValues.authorId}'>&authorId=${aId}</c:forEach><c:forEach var='pub' items='${paramValues.publisher}'>&publisher=${pub}</c:forEach>">${i}</a>
											</li>
										</c:if>
									</c:forEach>

									<%-- Dấu ... cuối nếu currentPage < totalPages - 2 --%>
									<c:if test="${currentPage < totalPages - 2}">
										<li class="page-item disabled"><a class="page-link">...</a></li>
									</c:if>

									<%-- Trang cuối luôn hiện --%>
									<c:if test="${totalPages > 1}">
										<li class="page-item"><a
											class="page-link ${currentPage == totalPages ? 'active' : ''}"
											href="${pageContext.request.contextPath}/books?page=${totalPages}&keyword=${param.keyword}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}&sort=${param.sort}<c:forEach var='id' items='${paramValues.categoryId}'>&categoryId=${id}</c:forEach><c:forEach var='yr' items='${paramValues.publishYear}'>&publishYear=${yr}</c:forEach><c:forEach var='aId' items='${paramValues.authorId}'>&authorId=${aId}</c:forEach><c:forEach var='pub' items='${paramValues.publisher}'>&publisher=${pub}</c:forEach>">${totalPages}</a>
										</li>
									</c:if>

									<%-- Next --%>
									<li
										class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
										<a class="page-link next"
										href="${pageContext.request.contextPath}/books?page=${currentPage + 1}&keyword=${param.keyword}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}&sort=${param.sort}<c:forEach var='id' items='${paramValues.categoryId}'>&categoryId=${id}</c:forEach><c:forEach var='yr' items='${paramValues.publishYear}'>&publishYear=${yr}</c:forEach><c:forEach var='aId' items='${paramValues.authorId}'>&authorId=${aId}</c:forEach><c:forEach var='pub' items='${paramValues.publisher}'>&publisher=${pub}</c:forEach>">
											&#10095; </a>
									</li>
									
									<%-- Đi đến trang --%>
<li class="page-item" style="display:flex; align-items:center; gap:6px; margin-left:8px;">
    <span style="font-size:13px; color:#555; white-space:nowrap;">Đi đến trang</span>
    <input id="goto-page-input" type="number" min="1" max="${totalPages}"
        style="width:55px; padding:4px 6px; border:1px solid #ddd; border-radius:4px; font-size:13px;"
        placeholder="...">
    <button onclick="goToPageBookList()" 
        style="padding:4px 10px; border:1px solid #ddd; border-radius:4px; background:#fff; cursor:pointer; font-size:13px;">→</button>
</li>
								</ul>
							</nav>
						</div>
					</div>
				</div>

			</div>
		</div>
	</div>

	<div class="bg-white py-5">
		<div class="container">
			<div
				class="swiper client-swiper swiper-initialized swiper-horizontal swiper-backface-hidden">
				<div class="swiper-wrapper" id="swiper-wrapper-7cdaae2b34727a6a"
					aria-live="off"
					style="transition-duration: 0ms; transform: translate3d(0px, 0px, 0px); transition-delay: 0ms;">
					<div class="swiper-slide swiper-slide-active" role="group"
						aria-label="1 / 5" style="width: 292.5px;">
						<img src="images/client/client1.svg" alt="client">
					</div>
					<div class="swiper-slide swiper-slide-next" role="group"
						aria-label="2 / 5" style="width: 292.5px;">
						<img src="images/client/client2.svg" alt="client">
					</div>
					<div class="swiper-slide" role="group" aria-label="3 / 5"
						style="width: 292.5px;">
						<img src="images/client/client3.svg" alt="client">
					</div>
					<div class="swiper-slide" role="group" aria-label="4 / 5"
						style="width: 292.5px;">
						<img src="images/client/client4.svg" alt="client">
					</div>
					<div class="swiper-slide" role="group" aria-label="5 / 5"
						style="width: 292.5px;">
						<img src="images/client/client5.svg" alt="client">
					</div>
				</div>
				<span class="swiper-notification" aria-live="assertive"
					aria-atomic="true"></span>
			</div>
		</div>
	</div>

	<section class="content-inner">
		<div class="container">
			<div class="row sp15">
				<div class="col-lg-3 col-md-6 col-sm-6 col-6">
					<div class="icon-bx-wraper style-2 m-b30 text-center">
						<div class="icon-bx-lg">
							<i class="fa-solid fa-users icon-cell"></i>
						</div>
						<div class="icon-content">
							<h2 class="dz-title counter m-b0">125,663</h2>
							<p class="font-20">Happy Customers</p>
						</div>
					</div>
				</div>
				<div class="col-lg-3 col-md-6 col-sm-6 col-6">
					<div class="icon-bx-wraper style-2 m-b30 text-center">
						<div class="icon-bx-lg">
							<i class="fa-solid fa-book icon-cell"></i>
						</div>
						<div class="icon-content">
							<h2 class="dz-title counter m-b0">50,672</h2>
							<p class="font-20">Book Collections</p>
						</div>
					</div>
				</div>
				<div class="col-lg-3 col-md-6 col-sm-6 col-6">
					<div class="icon-bx-wraper style-2 m-b30 text-center">
						<div class="icon-bx-lg">
							<i class="fa-solid fa-store icon-cell"></i>
						</div>
						<div class="icon-content">
							<h2 class="dz-title counter m-b0">1,562</h2>
							<p class="font-20">Our Stores</p>
						</div>
					</div>
				</div>
				<div class="col-lg-3 col-md-6 col-sm-6 col-6">
					<div class="icon-bx-wraper style-2 m-b30 text-center">
						<div class="icon-bx-lg">
							<i class="fa-solid fa-leaf icon-cell"></i>
						</div>
						<div class="icon-content">
							<h2 class="dz-title counter m-b0">457</h2>
							<p class="font-20">Famous Writers</p>
						</div>
					</div>
				</div>
			</div>
		</div>
	</section>

	<section class="py-5 newsletter-wrapper"
		style="background-image: url('images/background/bg1.jpg'); background-size: cover;">
		<div class="container">
			<div class="subscride-inner">
				<div
					class="row style-1 justify-content-xl-between justify-content-lg-center align-items-center text-xl-start text-center">
					<div class="col-xl-7 col-lg-12">
						<div class="section-head mb-0">
							<h2 class="title text-white my-lg-3 mt-0">Subscribe our
								newsletter for newest books updates</h2>
						</div>
					</div>
					<div class="col-xl-5 col-lg-6">
						<form class="dzSubscribe style-1" action="script/mailchamp.php"
							method="post">
							<div class="dzSubscribeMsg"></div>
							<div class="form-group">
								<div class="input-group mb-0">
									<input name="dzEmail" required="required" type="email"
										class="form-control bg-transparent text-white"
										placeholder="Your Email Address">
									<div class="input-group-addon">
										<button name="submit" value="Submit" type="submit"
											class="btn btn-primary btnhover">
											<span>SUBSCRIBE</span> <i class="fa-solid fa-paper-plane"></i>
										</button>
									</div>
								</div>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</section>
</div>

<style>
.dz-shop-card.style-1 {
	height: 100%;
	display: flex;
	flex-direction: column;
}

.dz-shop-card.style-1 .dz-media {
	height: 280px;
	overflow: hidden;
	flex-shrink: 0;
}

.dz-shop-card.style-1 .dz-media img {
	width: 100%;
	height: 100%;
	object-fit: cover;
}

.dz-shop-card.style-1 .dz-content {
	flex: 1;
	display: flex;
	flex-direction: column;
	padding-top: 15px;
}

.dz-shop-card.style-1 .book-footer {
	position: relative !important;
	bottom: auto !important;
	left: auto !important;
	width: 100% !important;
	opacity: 1 !important;
	visibility: visible !important;
	padding-bottom: 0 !important;
	background: transparent !important;
	border-radius: 0 !important;
	margin-top: auto;
}

.dz-shop-card.style-1 .dz-content .book-footer .btn {
	display: none !important;
}

.dz-shop-card.style-1:hover .dz-content .book-footer .btn {
	display: inline-flex !important;
}

.book-grid-row {
	display: flex;
	flex-wrap: wrap;
}

.book-grid-row .col-book {
	display: flex;
	flex-direction: column;
}

/* Ngăn noUiSlider ảnh hưởng ra ngoài */
#slider-tooltips .noUi-connects {
	border-radius: 3px;
}

#slider-tooltips .noUi-connect {
	background: #1a1668;
}

#slider-tooltips .noUi-handle {
	border-radius: 50%;
	cursor: pointer;
}

/* Reset lại .inner và .show bị noUiSlider override */
.dropdown-menu .inner.show {
	display: block !important;
	visibility: visible !important;
	opacity: 1 !important;
}

.bootstrap-select .dropdown-menu.show {
	display: block !important;
}

/* Ẩn mũi tên spin của input number */
input[type=number]::-webkit-inner-spin-button,
input[type=number]::-webkit-outer-spin-button {
    -webkit-appearance: none;
    margin: 0;
}
input[type=number] {
    -moz-appearance: textfield;
}
</style>

<script>
	document.querySelectorAll('.dropdown-item[id^="bs-select-2-"]').forEach(function(item) {
		item.addEventListener('click', function(e) {
			e.preventDefault();

			var map = {
				'Nổi bật': 'featured',
				'Tên: A → Z': 'name_asc',
				'Tên: Z → A': 'name_desc',
				'Giá: Thấp → Cao': 'price_asc',
				'Giá: Cao → Thấp': 'price_desc'
			};

			var text = this.querySelector('.text').textContent.trim();
			var value = map[text] || 'featured';

			document.querySelector('.filter-option-inner-inner').textContent = text;
			document.getElementById('sortInput').value = value;
			document.getElementById('filterForm').submit();
		});
	});
</script>

<script>
	document.addEventListener('DOMContentLoaded', function () {
		const ctx = '${pageContext.request.contextPath}';

		document.querySelectorAll('.add-to-cart-btn').forEach(function (btn) {
			btn.addEventListener('click', function (e) {
				e.preventDefault();

				const id = this.dataset.id;

				fetch(ctx + '/cart', {
					method: 'POST',
					headers: {
						'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
						'X-Requested-With': 'XMLHttpRequest'
					},
					body: 'action=add&id=' + encodeURIComponent(id) + '&quantity=1'
				})
						.then(function (res) {
							return res.json();
						})
						.then(function (data) {
							if (!data || !data.success) return;

							const badge = document.getElementById('cart-badge');
							if (badge) {
								badge.textContent = data.totalItems;
							}

							if (typeof updateMiniCartUI === 'function') {
								updateMiniCartUI(data);
							}

							showToast('Đã thêm vào giỏ hàng');
						})
						.catch(function (err) {
							console.error('Add to cart error:', err);
						});
			});
		});

		function showToast(message) {
			let toast = document.getElementById('cart-toast');

			if (!toast) {
				toast = document.createElement('div');
				toast.id = 'cart-toast';
				toast.style.position = 'fixed';
				toast.style.top = '20px';
				toast.style.right = '20px';
				toast.style.zIndex = '9999';
				toast.style.background = '#28a745';
				toast.style.color = '#fff';
				toast.style.padding = '10px 16px';
				toast.style.borderRadius = '8px';
				toast.style.boxShadow = '0 4px 12px rgba(0,0,0,.15)';
				document.body.appendChild(toast);
			}

			toast.textContent = message;
			toast.style.display = 'block';

			clearTimeout(toast._timer);
			toast._timer = setTimeout(function () {
				toast.style.display = 'none';
			}, 1500);
		}
	});
</script>






<script>
function removeFilter(name, value) {
    var url = new URL(window.location.href);
    var params = new URLSearchParams(url.search);
    if (name === 'price') {
        params.delete('minPrice');
        params.delete('maxPrice');
    } else if (name === 'keyword') {
        params.delete('keyword');
    } else {
        var existing = params.getAll(name);
        params.delete(name);
        existing.forEach(function(v) {
            if (v !== String(value)) params.append(name, v);
        });
    }
    params.set('page', '1');
    window.location.href = url.pathname + '?' + params.toString();
}
</script>

<%--đi đến trang --%>
<script>
function goToPageBookList() {
    var input = document.getElementById('goto-page-input');
    var val = parseInt(input.value);
    var total = ${totalPages};
    if (isNaN(val) || val < 1 || val > total) return;

    var url = new URL(window.location.href);
    url.searchParams.set('page', val);
    window.location.href = url.toString();
}

document.addEventListener('DOMContentLoaded', function() {
    var input = document.getElementById('goto-page-input');
    if (input) {
        input.addEventListener('keydown', function(e) {
            if (e.key === 'Enter') goToPageBookList();
        });
    }
});
</script>

<%@ include file="/WEB-INF/views/base/footer.jsp"%>