<div class="row">
  <div class="col-lg-6">
    <div id="riskContainer" class="alert alert-<%=riskCurrent.panelType%> event-title">Current pollution risk is <%=riskCurrent.text%>
      <canvas id="gauge-current" class="gauge" width="300" height="300"></canvas>
    </div>
  </div>
  <div class="col-lg-6">
    <div id="riskContainer" class="alert alert-<%=riskForecast.panelType%> event-title">Pollution risk for next 24 hours is <%=riskForecast.text%>
      <canvas id="gauge-future" class="gauge" width="300" height="300"></canvas>
    </div>
  </div>
</div>
<div class="row">
  <div class="col-lg-6">
    <div id="risk-chart"></div>
  </div>
  <div class="col-lg-6">
    <div id="future-risk-chart"></div>
  </div>
</div>
