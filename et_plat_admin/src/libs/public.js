/**
 * @description 表格列表中删除最后一页中的唯一一个数据的操作
 */
export function handleDeleteTable(length, tableFrom) {
  if (length === 1 && tableFrom.page > 1) return (tableFrom.page = tableFrom.page - 1);
}
