/// 集合每个之间插入item
List<T> join<T>(List<T> list, T item) {
    var size = list.length - 1;
    for (var i = 0; i < size; i ++) {
        list.insert(i * 2 + 1, item);
    }
    return list;
}

List<T> joinWrapper<T>(List<T> list, T wrapper(T item)) {
    return List.generate(list.length, (index) {
        if (index == list.length - 1) {
            return list[index];
        }
        return wrapper(list[index]);
    });
}

/// 判断是否网络
bool isNetWorkImg(String img) {
    return img.startsWith('http') || img.startsWith('https');
}

/// 判断是否资源图片
bool isAssetsImg(String img) {
    return img.startsWith('asset') || img.startsWith('assets');
}