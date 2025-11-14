const puppeteer = require('puppeteer');

// Template HTML para el reporte
const getReportTemplate = (data) => `
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reporte Solar - SolarEnergy</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', sans-serif;
            line-height: 1.6;
            color: #1E3A8A;
            background: linear-gradient(135deg, #F0F9FF 0%, #E0F2FE 100%);
            padding: 20px;
        }
        
        .header {
            text-align: center;
            margin-bottom: 30px;
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .logo {
            font-size: 3em;
            color: #FFB81C;
            margin-bottom: 10px;
        }
        
        .company-name {
            font-size: 2.5em;
            font-weight: bold;
            color: #1E3A8A;
            margin-bottom: 5px;
        }
        
        .subtitle {
            color: #6B7280;
            font-style: italic;
            font-size: 1.1em;
        }
        
        .section {
            background: white;
            margin: 20px 0;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            page-break-inside: avoid;
        }
        
        .section h2 {
            color: #1E3A8A;
            border-bottom: 3px solid #FFB81C;
            padding-bottom: 10px;
            margin-bottom: 20px;
            font-size: 1.5em;
        }
        
        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .card {
            background: #F0F9FF;
            padding: 20px;
            border-radius: 12px;
            border-left: 5px solid #FFB81C;
        }
        
        .card h3 {
            color: #1E3A8A;
            margin-top: 0;
            margin-bottom: 15px;
            font-size: 1.2em;
        }
        
        .data-row {
            display: flex;
            justify-content: space-between;
            margin: 10px 0;
            padding: 8px 0;
            border-bottom: 1px solid #E5E7EB;
        }
        
        .data-label {
            font-weight: 600;
            color: #374151;
        }
        
        .data-value {
            font-weight: bold;
            color: #10B981;
        }
        
        .chart-container {
            text-align: center;
            margin: 20px 0;
        }
        
        .chart-container img {
            max-width: 100%;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .projection-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        .projection-table th {
            background: #1E3A8A;
            color: white;
            padding: 12px;
            text-align: left;
            font-weight: bold;
        }
        
        .projection-table td {
            padding: 10px;
            border-bottom: 1px solid #E5E7EB;
        }
        
        .projection-table tr:nth-child(even) {
            background-color: #f8f9fa;
        }
        
        .conclusion {
            background: linear-gradient(135deg, #10B981, #059669);
            color: white;
            padding: 25px;
            border-radius: 15px;
            margin-top: 30px;
        }
        
        .conclusion h3 {
            margin-top: 0;
            margin-bottom: 15px;
            color: white;
            font-size: 1.3em;
        }
        
        .conclusion p {
            margin-bottom: 10px;
            line-height: 1.8;
        }
        
        .footer {
            text-align: center;
            margin-top: 30px;
            padding: 20px;
            color: #6B7280;
            font-size: 0.9em;
        }
        
        @media print {
            body {
                background: white;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="logo">⚡</div>
        <div class="company-name">SolarEnergy</div>
        <div class="subtitle">Energía limpia para un futuro sostenible</div>
        <div class="subtitle" style="margin-top: 10px;">Reporte generado el ${new Date().toLocaleDateString('es-ES')}</div>
    </div>

    <div class="section">
        <h2>Resumen del Sistema Solar</h2>
        <div class="grid">
            <div class="card">
                <h3>⚡ Especificaciones Técnicas</h3>
                <div class="data-row">
                    <span class="data-label">Potencia Requerida:</span>
                    <span class="data-value">${data.requiredKW}</span>
                </div>
                <div class="data-row">
                    <span class="data-label">Número de Paneles:</span>
                    <span class="data-value">${data.panelCount}</span>
                </div>
                <div class="data-row">
                    <span class="data-label">Área Necesaria:</span>
                    <span class="data-value">${data.requiredArea}</span>
                </div>
            </div>
            <div class="card">
                <h3>💰 Análisis Económico</h3>
                <div class="data-row">
                    <span class="data-label">Inversión Inicial:</span>
                    <span class="data-value">${data.estimatedCost}</span>
                </div>
                <div class="data-row">
                    <span class="data-label">Ahorro Mensual:</span>
                    <span class="data-value">${data.monthlySavings}</span>
                </div>
                <div class="data-row">
                    <span class="data-label">Ahorro Anual:</span>
                    <span class="data-value">${data.annualSavings}</span>
                </div>
                <div class="data-row">
                    <span class="data-label">Retorno de Inversión:</span>
                    <span class="data-value">${data.roiYears}</span>
                </div>
            </div>
        </div>
    </div>

    <div class="section">
        <h2>Comparación de Costos</h2>
        <div class="chart-container">
            <canvas id="costChart" width="600" height="300"></canvas>
        </div>
    </div>

    <div class="section">
        <h2>Proyección de Ahorros a 10 Años</h2>
        <table class="projection-table">
            <thead>
                <tr>
                    <th>Período</th>
                    <th>Ahorro Acumulado (milllones)</th>
                </tr>
            </thead>
            <tbody>
                ${generateProjectionRows(data.annualSavingsNumber)}
            </tbody>
        </table>
    </div>

    <div class="conclusion">
        <h3>Conclusiones del Análisis</h3>
        <p><strong>Viabilidad Técnica:</strong> El sistema solar propuesto está dimensionado correctamente para sus necesidades energéticas actuales, con una eficiencia óptima de conversión solar.</p>
        
        <p><strong>Rentabilidad Económica:</strong> La inversión inicial se recupera en ${data.roiYears}, generando ahorros significativos durante los 25+ años de vida útil del sistema.</p>
        
        <p><strong>Impacto Ambiental:</strong> Su sistema evitará aproximadamente <strong>${Math.round(data.annualSavingsNumber / 500)} toneladas de CO₂</strong> anuales, contribuyendo positivamente al medio ambiente.</p>
        
        <p><strong>Recomendación:</strong> SolarEnergy recomienda proceder con la instalación del sistema propuesto, ya que representa una inversión inteligente con beneficios económicos y ambientales comprobados.</p>
    </div>

    <div class="footer">
        <p>&copy; ${new Date().getFullYear()} SolarEnergy. Todos los derechos reservados.</p>
        <p>Reporte generado automáticamente por el sistema SolarEnergy</p>
    </div>

    <script>
        // Generar gráfico de comparación
        const ctx = document.getElementById('costChart').getContext('2d');
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ['Costo Actual', 'Con Paneles Solares'],
                datasets: [{
                    label: 'Costo Mensual (COP)',
                    data: [${data.bill}, ${data.bill - parseFloat(data.monthlySavings.replace(/[^\d.-]/g, ''))}],
                    backgroundColor: [
                        'rgba(30, 58, 138, 0.8)',
                        'rgba(16, 185, 129, 0.8)'
                    ],
                    borderColor: [
                        'rgba(30, 58, 138, 1)',
                        'rgba(16, 185, 129, 1)'
                    ],
                    borderWidth: 2,
                    borderRadius: 8
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        display: false
                    },
                    title: {
                        display: true,
                        text: 'Comparación de Costos Mensuales',
                        font: {
                            size: 16,
                            weight: 'bold'
                        },
                        color: '#1E3A8A'
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return '$' + value.toLocaleString('es-CO');
                            },
                            color: '#374151'
                        },
                        grid: {
                            color: '#E5E7EB'
                        }
                    },
                    x: {
                        ticks: {
                            color: '#374151'
                        },
                        grid: {
                            display: false
                        }
                    }
                }
            }
        });
    </script>
</body>
</html>
`;

// Función para generar filas de proyección
function generateProjectionRows(annualSaving) {
    let rows = '';
    let cumulativeSavings = 0;
    
    for (let year = 1; year <= 10; year++) {
        cumulativeSavings += annualSaving;
        rows += `
            <tr>
                <td>Año ${year}</td>
                <td style="color: #10B981; font-weight: bold;">$${cumulativeSavings.toLocaleString('es-CO')} COP</td>
            </tr>
        `;
    }
    
    return rows;
}



// Controlador principal para generar PDF
const generatePDF = async (req, res) => {
    try {
        const {
            consumption,
            bill,
            roofType,
            orientation,
            requiredKW,
            panelCount,
            requiredArea,
            estimatedCost,
            monthlySavings,
            annualSavings,
            roiYears
        } = req.body;

        // Validar datos requeridos
        if (!requiredKW || !panelCount || !requiredArea || !estimatedCost || !monthlySavings || !annualSavings || !roiYears) {
            return res.status(400).json({
                error: 'Datos incompletos para generar el reporte'
            });
        }

        // Extraer números para cálculos
        const currentBill = parseFloat(bill);
        const monthlySavingsNumber = parseFloat(monthlySavings.replace(/[^\d.-]/g, ''));
        const annualSavingsNumber = parseFloat(annualSavings.replace(/[^\d.-]/g, ''));

        // Preparar datos para el template
        const reportData = {
            requiredKW,
            panelCount,
            requiredArea,
            estimatedCost,
            monthlySavings,
            annualSavings,
            roiYears,
            annualSavingsNumber,
            consumption,
            bill: `$${currentBill.toLocaleString('es-CO')} COP`,
            roofType,
            orientation
        };

        // Generar HTML
        const html = getReportTemplate(reportData);

        // Configurar Puppeteer
        const browser = await puppeteer.launch({
            headless: 'new',
            args: ['--no-sandbox', '--disable-setuid-sandbox']
        });

        const page = await browser.newPage();
        
        // Configurar página para PDF
        await page.setContent(html, { 
            waitUntil: 'networkidle0' 
        });

        // Generar PDF
        const pdf = await page.pdf({
            format: 'A4',
            printBackground: true,
            margin: {
                top: '20px',
                right: '20px',
                bottom: '20px',
                left: '20px'
            }
        });

        await browser.close();

        // Configurar headers para descarga
        const filename = `Reporte_SolarEnergy_${new Date().toISOString().slice(0,10)}.pdf`;
        
        res.setHeader('Content-Type', 'application/pdf');
        res.setHeader('Content-Disposition', `attachment; filename="${filename}"`);
        res.setHeader('Content-Length', pdf.length);

        // Enviar PDF
        res.send(pdf);

    } catch (error) {
        console.error('Error generando PDF:', error);
        res.status(500).json({
            error: 'Error interno del servidor al generar el reporte PDF'
        });
    }
};

module.exports = {
    generatePDF
};