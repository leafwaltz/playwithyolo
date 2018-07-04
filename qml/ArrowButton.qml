import QtQuick 2.7

Rectangle
{
    color: "transparent"

    property string direction: ""
    property string borderColor: ""
    property string interColor: ""
    property int borderWidth: 1

    Canvas
    {
        id: arrow

        anchors.fill: parent

        onPaint:
        {
            var ctx = getContext('2d')
            ctx.strokeStyle = borderColor
            ctx.fillStyle = interColor
            ctx.lineWidth = borderWidth
            ctx.beginPath()

            if(direction.toLowerCase() == "left")
            {
                ctx.moveTo(0, arrow.height / 2)
                ctx.lineTo(arrow.width, 0)
                ctx.lineTo(arrow.width, arrow.height)
                ctx.lineTo(0, arrow.height / 2)
            }
            else if(direction.toLowerCase() == "right")
            {
                ctx.moveTo(arrow.width, arrow.height / 2)
                ctx.lineTo(0, arrow.height)
                ctx.lineTo(0, 0)
                ctx.lineTo(arrow.width, arrow.height / 2)
            }

            ctx.stroke()
            ctx.fill()
        }
    }
}
