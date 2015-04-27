USE [master]
GO
/****** Object:  StoredProcedure [dbo].[dataGrid]    Script Date: 04/27/2015 17:43:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[dataGrid]
	@flag INT,
	@criterio VARCHAR(200),
	@pagina INT,
	@reg_x_pag INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @maximo numeric
	DECLARE @minimo numeric
    
    SELECT @maximo = (@pagina * @reg_x_pag)
    SELECT @minimo = @maximo - (@reg_x_pag - 1)
    
    --CREACION DE LA TABLA TEMPORAL PARA LA PAGINACION
    --NUM_ORDEN SERVIRA DE INDICE PARA EXTRAER LOS REGISTROS

	-- AQUI TU TABLA
    CREATE TABLE #tmpListado(
        num_orden int IDENTITY(1,1),
		name nvarchar(35) NULL,
        status int NULL
    )
    
    --INSERTAR LOS DATOS A LA TABLA TEMPORAL DIRECTAMENTE DESDE EL SELECT
    INSERT #tmpListado 
    SELECT 
		name,
		status 
	FROM dbo.spt_values 
	WHERE name LIKE '%'+@criterio+'%' -- PARA CUANDO QUIERAS FILTRAR
	
	--UNA VEZ CARGADOS LOS DATOS LOS EXTRAEMOS
    --CON UN SELECT FILTRADO POR LOS VALORES DE LA PAGINACION
    SELECT 
		name,
		status
    FROM #tmpListado
    WHERE num_orden BETWEEN @minimo AND @maximo
END
