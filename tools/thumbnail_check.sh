#!/bin/bash

cd `dirname $0`
cd ..
BASE_DIR=`pwd`

GEN_CMD=$1
if [[ ! -f $GEN_CMD ]] ; then
  echo "No generate-thumbnail command."
  exit 1
fi
GEN_CMD="/bin/bash ${GEN_CMD}"

OUTPUT_DIR=/tmp

${GEN_CMD}
if [[ $? != 1 ]] ; then
  exit 1
fi

${GEN_CMD} x
if [[ $? != 1 ]] ; then
  exit 1
fi

echo "Generating DOC"
${GEN_CMD} msoffice file:$BASE_DIR/msoffice/test.doc  $OUTPUT_DIR/test_doc.png
if [[ $? != 0 ]] ; then
  exit 1
fi
echo "Generating DOCX"
${GEN_CMD} msoffice file:$BASE_DIR/msoffice/test.docx $OUTPUT_DIR/test_docx.png
if [[ $? != 0 ]] ; then
  exit 1
fi
echo "Generating PPT"
${GEN_CMD} msoffice file:$BASE_DIR/msoffice/test.ppt  $OUTPUT_DIR/test_ppt.png
if [[ $? != 0 ]] ; then
  exit 1
fi
echo "Generating PPTX"
${GEN_CMD} msoffice file:$BASE_DIR/msoffice/test.pptx $OUTPUT_DIR/test_pptx.png
if [[ $? != 0 ]] ; then
  exit 1
fi
echo "Generating XLS"
${GEN_CMD} msoffice file:$BASE_DIR/msoffice/test.xls  $OUTPUT_DIR/test_xls.png
if [[ $? != 0 ]] ; then
  exit 1
fi
echo "Generating XLSX"
${GEN_CMD} msoffice file:$BASE_DIR/msoffice/test.xlsx $OUTPUT_DIR/test_xlsx.png
if [[ $? != 0 ]] ; then
  exit 1
fi
echo "Generating RTF"
${GEN_CMD} msoffice file:$BASE_DIR/msoffice/test.rtf  $OUTPUT_DIR/test_rtf.png
if [[ $? != 0 ]] ; then
  exit 1
fi
echo "Generating PDF"
${GEN_CMD} pdf file:$BASE_DIR/pdf/test.pdf $OUTPUT_DIR/test_pdf.png
if [[ $? != 0 ]] ; then
  exit 1
fi
echo "Generating PS"
${GEN_CMD} ps file:$BASE_DIR/pdf/test.ps $OUTPUT_DIR/test_ps.png
if [[ $? != 0 ]] ; then
  exit 1
fi












