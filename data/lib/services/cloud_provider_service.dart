abstract class CloudProviderService {
  const CloudProviderService();

  Future<String?> createFolder(String folderName);

  Future<String?> getBackUpFolderId();
}
