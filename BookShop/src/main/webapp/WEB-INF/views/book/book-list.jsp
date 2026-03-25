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
							type="hidden" name="maxPrice" id="maxPriceInput">
						<div class="shop-filter">
							<div class="d-flex justify-content-between">
								<h4 class="title">Lựa chọn lọc</h4>
								<a href="javascript:void(0);" class="panel-close-btn"><i
									class="flaticon-close"></i></a>
							</div>
							<div class="accordion accordion-filter" id="accordionExample">

								<div class="accordion-item">
									<button class="accordion-button" id="headingFive" type="button"
										data-bs-toggle="collapse" data-bs-target="#collapseFive"
										aria-expanded="false" aria-controls="collapseFive"
										fdprocessedid="87d6rq">Mức giá</button>
									<div id="collapseFive"
										class="accordion-collapse collapse accordion-body show"
										aria-labelledby="headingFive"
										data-bs-parent="#accordionExample">
										<div class="range-slider style-1">
											<div id="slider-tooltips"
												class="noUi-target noUi-ltr noUi-horizontal noUi-txt-dir-ltr">
												<div class="noUi-base">
													<div class="noUi-connects">
														<div class="noUi-connect"
															style="transform: translate(40%, 0px) scale(0.4, 1);"></div>
													</div>
													<div class="noUi-origin"
														style="transform: translate(-60%, 0px); z-index: 5;">
														<div class="noUi-handle noUi-handle-lower" data-handle="0"
															tabindex="0" role="slider" aria-orientation="horizontal"
															aria-valuemin="0.0" aria-valuemax="80.0"
															aria-valuenow="40.0" aria-valuetext="40.00">
															<div class="noUi-touch-area"></div>
															<div class="noUi-tooltip">40.0</div>
														</div>
													</div>
													<div class="noUi-origin"
														style="transform: translate(-20%, 0px); z-index: 4;">
														<div class="noUi-handle noUi-handle-upper" data-handle="1"
															tabindex="0" role="slider" aria-orientation="horizontal"
															aria-valuemin="40.0" aria-valuemax="100.0"
															aria-valuenow="80.0" aria-valuetext="80.00">
															<div class="noUi-touch-area"></div>
															<div class="noUi-tooltip">80.00</div>
														</div>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
								<div class="accordion-item">
									<button class="accordion-button" id="headingOne" type="button"
										data-bs-toggle="collapse" data-bs-target="#collapseOne"
										aria-expanded="true" aria-controls="collapseOne"
										fdprocessedid="w8693ls">Chọn danh mục</button>
									<div id="collapseOne"
										class="accordion-collapse collapse show accordion-body"
										aria-labelledby="headingOne"
										data-bs-parent="#accordionExample">
										<div
											class="widget dz-widget_services d-flex justify-content-between">
											<div class="">
												<c:forEach var="cat" items="${categories}"
													varStatus="status">
													<c:if test="${status.index % 2 == 0}">
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
											<div class="">
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
								<div class="accordion-item">
									<button class="accordion-button collapsed" id="headingTwo"
										type="button" data-bs-toggle="collapse"
										data-bs-target="#collapseTwo" aria-expanded="false"
										aria-controls="collapseTwo" fdprocessedid="a1uoc">
										Choose Publisher</button>
									<div id="collapseTwo"
										class="accordion-collapse collapse accordion-body"
										aria-labelledby="headingTwo"
										data-bs-parent="#accordionExample">
										<div class="widget dz-widget_services">
											<div class="form-check search-content">
												<input class="form-check-input" type="checkbox" value=""
													id="productCheckBox15"> <label
													class="form-check-label" for="productCheckBox15">
													Action </label>
											</div>
											<div class="form-check search-content">
												<input class="form-check-input" type="checkbox" value=""
													id="productCheckBox16"> <label
													class="form-check-label" for="productCheckBox16">
													Advanture </label>
											</div>
											<div class="form-check search-content">
												<input class="form-check-input" type="checkbox" value=""
													id="productCheckBox17"> <label
													class="form-check-label" for="productCheckBox17">
													Animation </label>
											</div>
											<div class="form-check search-content">
												<input class="form-check-input" type="checkbox" value=""
													id="productCheckBox18"> <label
													class="form-check-label" for="productCheckBox18">
													Biography </label>
											</div>
											<div class="form-check search-content">
												<input class="form-check-input" type="checkbox" value=""
													id="productCheckBox19"> <label
													class="form-check-label" for="productCheckBox19">
													Comedy </label>
											</div>
											<div class="form-check search-content">
												<input class="form-check-input" type="checkbox" value=""
													id="productCheckBox20"> <label
													class="form-check-label" for="productCheckBox20">
													Crime </label>
											</div>
											<div class="form-check search-content">
												<input class="form-check-input" type="checkbox" value=""
													id="productCheckBox21"> <label
													class="form-check-label" for="productCheckBox21">
													Documentary </label>
											</div>
										</div>
									</div>
								</div>
								<div class="accordion-item">
									<button class="accordion-button collapsed" id="headingThree"
										type="button" data-bs-toggle="collapse"
										data-bs-target="#collapseThree" aria-expanded="false"
										aria-controls="collapseThree" fdprocessedid="c8b7bh">
										Select Year</button>
									<div id="collapseThree"
										class="accordion-collapse collapse accordion-body"
										aria-labelledby="headingThree"
										data-bs-parent="#accordionExample">
										<div
											class="widget dz-widget_services col d-flex justify-content-between">
											<div class="">
												<div class="form-check search-content">
													<input class="form-check-input" type="checkbox" value=""
														id="productCheckBox22"> <label
														class="form-check-label" for="productCheckBox22">
														2020 </label>
												</div>
												<div class="form-check search-content">
													<input class="form-check-input" type="checkbox" value=""
														id="productCheckBox23"> <label
														class="form-check-label" for="productCheckBox23">
														2021 </label>
												</div>
												<div class="form-check search-content">
													<input class="form-check-input" type="checkbox" value=""
														id="productCheckBox24"> <label
														class="form-check-label" for="productCheckBox24">
														2024 </label>
												</div>
												<div class="form-check search-content">
													<input class="form-check-input" type="checkbox" value=""
														id="productCheckBox25"> <label
														class="form-check-label" for="productCheckBox25">
														2019 </label>
												</div>
												<div class="form-check search-content">
													<input class="form-check-input" type="checkbox" value=""
														id="productCheckBox26"> <label
														class="form-check-label" for="productCheckBox26">
														2018 </label>
												</div>
												<div class="form-check search-content">
													<input class="form-check-input" type="checkbox" value=""
														id="productCheckBox27"> <label
														class="form-check-label" for="productCheckBox27">
														2017 </label>
												</div>
												<div class="form-check search-content">
													<input class="form-check-input" type="checkbox" value=""
														id="productCheckBox28"> <label
														class="form-check-label" for="productCheckBox28">
														2016 </label>
												</div>
												<div class="form-check search-content">
													<input class="form-check-input" type="checkbox" value=""
														id="productCheckBox29"> <label
														class="form-check-label" for="productCheckBox29">
														2015 </label>
												</div>
												<div class="form-check search-content">
													<input class="form-check-input" type="checkbox" value=""
														id="productCheckBox30"> <label
														class="form-check-label" for="productCheckBox30">
														2014 </label>
												</div>
												<div class="form-check search-content">
													<input class="form-check-input" type="checkbox" value=""
														id="productCheckBox31"> <label
														class="form-check-label" for="productCheckBox31">
														2013 </label>
												</div>
												<div class="form-check search-content">
													<input class="form-check-input" type="checkbox" value=""
														id="productCheckBox32"> <label
														class="form-check-label" for="productCheckBox32">
														2012 </label>
												</div>
											</div>
											<div class="">
												<div class="form-check search-content">
													<input class="form-check-input" type="checkbox" value=""
														id="productCheckBox33"> <label
														class="form-check-label" for="productCheckBox33">
														2011 </label>
												</div>
												<div class="form-check search-content">
													<input class="form-check-input" type="checkbox" value=""
														id="productCheckBox34"> <label
														class="form-check-label" for="productCheckBox34">
														2010 </label>
												</div>
												<div class="form-check search-content">
													<input class="form-check-input" type="checkbox" value=""
														id="productCheckBox35"> <label
														class="form-check-label" for="productCheckBox35">
														2009 </label>
												</div>
												<div class="form-check search-content">
													<input class="form-check-input" type="checkbox" value=""
														id="productCheckBox36"> <label
														class="form-check-label" for="productCheckBox36">
														2008 </label>
												</div>
												<div class="form-check search-content">
													<input class="form-check-input" type="checkbox" value=""
														id="productCheckBox37"> <label
														class="form-check-label" for="productCheckBox37">
														2007 </label>
												</div>
												<div class="form-check search-content">
													<input class="form-check-input" type="checkbox" value=""
														id="productCheckBox38"> <label
														class="form-check-label" for="productCheckBox38">
														2006 </label>
												</div>
												<div class="form-check search-content">
													<input class="form-check-input" type="checkbox" value=""
														id="productCheckBox39"> <label
														class="form-check-label" for="productCheckBox39">
														2005 </label>
												</div>
												<div class="form-check search-content">
													<input class="form-check-input" type="checkbox" value=""
														id="productCheckBox40"> <label
														class="form-check-label" for="productCheckBox40">
														2004 </label>
												</div>
												<div class="form-check search-content">
													<input class="form-check-input" type="checkbox" value=""
														id="productCheckBox41"> <label
														class="form-check-label" for="productCheckBox41">
														2003 </label>
												</div>
												<div class="form-check search-content">
													<input class="form-check-input" type="checkbox" value=""
														id="productCheckBox42"> <label
														class="form-check-label" for="productCheckBox42">
														2002 </label>
												</div>
												<div class="form-check search-content">
													<input class="form-check-input" type="checkbox" value=""
														id="productCheckBox43"> <label
														class="form-check-label" for="productCheckBox43">
														2001 </label>
												</div>
											</div>
										</div>
									</div>
								</div>
								<div class="accordion accordion-inner" id="filter-inner">
									<div class="accordion-item">
										<button class="accordion-button" id="headingOne_inner"
											type="button" data-bs-toggle="collapse"
											data-bs-target="#collapseOne_inner" aria-expanded="true"
											aria-controls="collapseOne_inner" fdprocessedid="rscqcd">Best
											Sales (105)</button>
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
											id="headingTwo_inner" type="button" data-bs-toggle="collapse"
											data-bs-target="#collapseTwo_inner" aria-expanded="false"
											aria-controls="collapseTwo_inner" fdprocessedid="yth0j">
											Most Commented (21)</button>
										<div id="collapseTwo_inner"
											class="accordion-collapse collapse accordion-body"
											aria-labelledby="headingTwo_inner"
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
											aria-controls="collapseThree_inner" fdprocessedid="ww1ny">
											Newest Books (32)</button>
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
											id="headingFour_inner" type="button"
											data-bs-toggle="collapse"
											data-bs-target="#collapseFour_inner" aria-expanded="false"
											aria-controls="collapseFour_inner" fdprocessedid="cylde">
											Featured (129)</button>
										<div id="collapseFour_inner"
											class="accordion-collapse collapse accordion-body"
											aria-labelledby="headingFour_inner"
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
											aria-controls="collapseFive_inner" fdprocessedid="6qteop">
											Watch History (21)</button>
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
											aria-controls="collapseSix_inner" fdprocessedid="bp2nvl">
											Best Books (44)</button>
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
										class="btn btn-secondary btnhover mt-4 d-block w-100">Refine
										Search</button>
									<a href="${pageContext.request.contextPath}/books"
										class="btn btn-outline-secondary btnhover mt-3 d-block">Reset
										Filter</a>
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
													d="M14 22H21C21.2652 22 21.5196 21.8946 21.7071 21.7071C21.8946 21.5196 22 21.2652 22 21V14C22 13.7348 21.8946 13.4804 21.7071 13.2929C21.5196 13.1054 21.2652 13 21 13H14C13.7348 13 13.4804 13.1054 13.2929 13.2929C13.1054 13.4804 13 13.7348 13 14V21C13 21.2652 13.1054 21.5196 13.2929 21.7071C13.4804 21.8946 13.7348 22 14 22ZM15 15H20V20H15V15Z"
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
							<div class="filter-category">
								<a data-bs-toggle="collapse" href="#collapseExample"
									role="button" aria-expanded="false"
									aria-controls="collapseExample" class="collapsed"> <i
									class="fas fa-list me-2"></i> Danh Mục
								</a>
							</div>
							<div class="form-group">
								<i class="fas fa-sort-amount-down me-2 text-secondary"></i>
								<div class="dropdown bootstrap-select default-select dropup">
									<select class="default-select" tabindex="null">
										<option>Newest</option>
										<option>1 Day</option>
										<option>1 Week</option>
										<option>3 Weeks</option>
										<option>1 Month</option>
										<option>3 Months</option>
									</select>
									<button type="button" tabindex="-1"
										class="btn dropdown-toggle btn-light"
										data-bs-toggle="dropdown" role="combobox"
										aria-owns="bs-select-2" aria-haspopup="listbox"
										aria-expanded="false" title="Newest">
										<div class="filter-option">
											<div class="filter-option-inner">
												<div class="filter-option-inner-inner">Newest</div>
											</div>
										</div>
									</button>
									<div class="dropdown-menu"
										style="max-height: 285.2px; overflow: hidden; min-height: 112px;">
										<div class="inner show" role="listbox" id="bs-select-2"
											tabindex="-1" aria-activedescendant="bs-select-2-0"
											style="max-height: 269.2px; overflow-y: auto; min-height: 96px;">
											<ul class="dropdown-menu inner show" role="presentation"
												style="margin-top: 0px; margin-bottom: 0px;">
												<li class="selected active"><a role="option"
													class="dropdown-item active selected" id="bs-select-2-0"
													tabindex="0" aria-setsize="6" aria-posinset="1"
													aria-selected="true"><span class="text">Newest</span></a></li>
												<li><a role="option" class="dropdown-item"
													id="bs-select-2-1" tabindex="0"><span class="text">1
															Day</span></a></li>
												<li><a role="option" class="dropdown-item"
													id="bs-select-2-2" tabindex="0"><span class="text">1
															Week</span></a></li>
												<li><a role="option" class="dropdown-item"
													id="bs-select-2-3" tabindex="0"><span class="text">3
															Weeks</span></a></li>
												<li><a role="option" class="dropdown-item"
													id="bs-select-2-4" tabindex="0"><span class="text">1
															Month</span></a></li>
												<li><a role="option" class="dropdown-item"
													id="bs-select-2-5" tabindex="0"><span class="text">3
															Months</span></a></li>
											</ul>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="acod-content collapse" id="collapseExample" style="">
						<div class="widget widget_services style-2">
							<c:forEach var="cat" items="${categories}">
								<div class="form-check search-content">
									<input class="form-check-input" type="checkbox"
										value="${cat.id}" id="cat${cat.id}"> <label
										class="form-check-label" for="cat${cat.id}">
										${cat.name} </label>
								</div>
							</c:forEach>
						</div>
					</div>
					<div class="row book-grid-row">
						<c:forEach var="b" items="${books}">
							<div class="col-book style-2">
								<div class="dz-shop-card style-1">
									<div class="dz-media">
										<img
											src="${not empty b.image 
    ? pageContext.request.contextPath.concat('/assets/images/books/').concat(b.image)
    : pageContext.request.contextPath.concat('/assets/images/books/default-book.png')}"
											alt="${b.title}">
									</div>
									<div class="bookmark-btn style-2">
										<input class="form-check-input" type="checkbox"
											id="flexCheckDefault1"> <label
											class="form-check-label" for="flexCheckDefault1"> <i
											class="flaticon-heart"></i>
										</label>
									</div>
									<div class="dz-content">
										<h5 class="title">
											<a
												href="${pageContext.request.contextPath}/books/detail?id=${b.id}">${b.title}</a>
										</h5>
										<ul class="dz-tags">
											<li><a href="books-grid-view.html">${b.category.name}</a></li>

										</ul>
										<ul class="dz-rating">
											<li><i class="flaticon-star text-yellow"></i></li>
											<li><i class="flaticon-star text-yellow"></i></li>
											<li><i class="flaticon-star text-yellow"></i></li>
											<li><i class="flaticon-star text-yellow"></i></li>
											<li><i class="flaticon-star text-muted"></i></li>
										</ul>
										<div class="book-footer">
											<div class="price">
												<span class="price-num"><fmt:formatNumber
														value="${b.price}" pattern="#,###" />&#8363;</span>
												<del>$12.0</del>
											</div>
											<a href="shop-cart.html"
												class="btn btn-secondary box-btn btnhover btnhover2"><i
												class="flaticon-shopping-cart-1 m-r10"></i> Add to cart</a>
										</div>
									</div>
								</div>
							</div>
						</c:forEach>

					</div>
					<div class="row page mt-0">
						<div class="col-md-6">
							<p class="page-text">Showing 12 from 50 data</p>
						</div>
						<div class="col-md-6">
							<nav aria-label="Blog Pagination">
								<ul class="pagination style-1 p-t20">
									<li class="page-item"><a class="page-link prev"
										href="javascript:void(0);">Prev</a></li>
									<li class="page-item"><a class="page-link active"
										href="javascript:void(0);">1</a></li>
									<li class="page-item"><a class="page-link"
										href="javascript:void(0);">2</a></li>
									<li class="page-item"><a class="page-link"
										href="javascript:void(0);">3</a></li>
									<li class="page-item"><a class="page-link next"
										href="javascript:void(0);">Next</a></li>
								</ul>
							</nav>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- Client Start-->
	<div class="bg-white py-5">
		<div class="container">
			<!--Client Swiper -->
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
	<!-- Client End-->

	<!-- Feature Box -->
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
				<div class=" col-lg-3 col-md-6 col-sm-6 col-6">
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
	<!-- Feature Box End -->

	<!-- Newsletter -->
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
										placeholder="Your Email Address" fdprocessedid="amyxt">
									<div class="input-group-addon">
										<button name="submit" value="Submit" type="submit"
											class="btn btn-primary btnhover" fdprocessedid="vn8wzo">
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
	<!-- Newsletter End -->

</div>

<%@ include file="/WEB-INF/views/base/footer.jsp"%>