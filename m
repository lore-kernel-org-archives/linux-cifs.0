From: Tim Gardner <timg@tpi.com>
Subject: [PATCH 1/4 linux-next V3] cifs: Replace CIFSSMBSetEOF() with smb_set_file_size()
Date: Mon,  9 Dec 2013 12:41:53 -0700
Message-ID: <1386618116-9672-1-git-send-email-timg@tpi.com>
Cc: Steve French <sfrench@samba.org>, Tim Gardner <timg@tpi.com>, Dean Gehnert <deang@tpi.com>, Jeff Layton <jlayton@redhat.com>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Return-path: <samba-technical-bounces@lists.samba.org>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

According to Microsoft documentation:
		http://msdn.microsoft.com/en-us/library/ee441943.aspx
		http://msdn.microsoft.com/en-us/library/ff469854.aspx

The information level codes used in CIFSSMBSetEOF() are not
legal. In practice we have found that they really don't work either.
The specification clearly states that none of the SMB_SET_FILE infornmation
level codes are supported for TRANS2_SET_PATH_INFORMATION.

You can trigger this function with the following C code. Note that O_CREAT|O_TRUNC
is not a valid combination, but it does serve to illustrate the bug.

cat <<EOF > truncate.c

int main(int argc, char *argv[])
{
	char *fname;
	int fd;
	mode_t mode = S_IRUSR|S_IWUSR;
	int flags = O_CREAT|O_TRUNC;

	if (argc == 2) {
		fname = argv[1];
	} else {
		printf("You must supply a file name.\n");
		exit(1);
	}

	if ((fd=open(fname,flags,mode))  < 0)
	{
		printf("could not open %s with flags %08x\n",fname,flags);
		exit(1);
	}
	printf("Opened %s with flags %08x\n",fname,flags);

	close(fd);
}
EOF

I used this script:

cat <<EOF > truncate.sh
LOG=log.txt
SRV=10.0.0.184
MP=/tmp/mnt
TD=$MP/temp

gcc -o truncate truncate.c
rm -f $LOG

sudo mkdir -p $MP
sudo mount -t cifs //$SRV/test $MP --verbose -o noserverino,nounix,user=test,pass=test

mkdir -p $TD
sudo rm -f $TD/junk.txt
echo 1 > junk.txt
sudo cp junk.txt $TD/junk.txt
sudo dmesg -c > /dev/null

echo 1 | sudo tee /proc/fs/cifs/cifsFYI
sudo ./truncate $TD/junk.txt
echo 0 | sudo tee /proc/fs/cifs/cifsFYI

sudo umount $MP
sudo dmesg -c > $LOG
EOF

The resulting log file:

[179777.458893] fs/cifs/file.c:cifs_open:447: CIFS VFS: in cifs_open as Xid: 654 with uid: 0
[179777.458903] fs/cifs/dir.c:build_path_from_dentry:127: name: \junk.txt
[179777.458907] fs/cifs/dir.c:build_path_from_dentry:127: name: \temp\junk.txt
[179777.458922] fs/cifs/file.c:cifs_open:465: inode = 0xffff88005a42b828 file flags are 0x8240 for \temp\junk.txt
[179777.458935] fs/cifs/transport.c:AllocMidQEntry:64: For smb_command 162
[179777.458938] fs/cifs/transport.c:smb_send_rqst:288: Sending smb: smb_len=114
[179777.460089] fs/cifs/connect.c:cifs_demultiplex_thread:874: RFC1002 header 0x67
[179777.460109] fs/cifs/misc.c:checkSMB:316: checkSMB Length: 0x6b, smb_buf_length: 0x67
[179777.460125] fs/cifs/transport.c:cifs_sync_mid_result:571: cifs_sync_mid_result: cmd=162 mid=20 state=4
[179777.460134] fs/cifs/inode.c:cifs_get_inode_info:646: Getting info on \temp\junk.txt
[179777.460138] fs/cifs/inode.c:cifs_revalidate_cache:95: cifs_revalidate_cache: revalidating inode 320
[179777.460141] fs/cifs/inode.c:cifs_revalidate_cache:119: cifs_revalidate_cache: invalidating inode 320 mapping
[179777.460148] fs/cifs/file.c:cifs_open:545: CIFS VFS: leaving cifs_open (xid = 654) rc = 0
[179777.460153] fs/cifs/inode.c:cifs_setattr:2280: name junk.txt size 0
[179777.460157] fs/cifs/inode.c:cifs_setattr_nounix:2126: CIFS VFS: in cifs_setattr_nounix as Xid: 655 with uid: 0
[179777.460160] fs/cifs/inode.c:cifs_setattr_nounix:2129: setattr on file junk.txt attrs->iavalid 0xa068
[179777.460163] fs/cifs/dir.c:build_path_from_dentry:127: name: \junk.txt
[179777.460166] fs/cifs/dir.c:build_path_from_dentry:127: name: \temp\junk.txt
[179777.460170] fs/cifs/cifssmb.c:CIFSSMBSetEOF:5403: In SetEOF
[179777.460175] fs/cifs/transport.c:AllocMidQEntry:64: For smb_command 50
[179777.460178] fs/cifs/transport.c:smb_send_rqst:288: Sending smb: smb_len=112
[179777.460810] fs/cifs/connect.c:cifs_demultiplex_thread:874: RFC1002 header 0x23
[179777.460827] fs/cifs/misc.c:checkSMB:316: checkSMB Length: 0x27, smb_buf_length: 0x23
[179777.460830] fs/cifs/smb1ops.c:check2ndT2:255: invalid transact2 word count
[179777.460841] fs/cifs/transport.c:cifs_sync_mid_result:571: cifs_sync_mid_result: cmd=50 mid=21 state=4
[179777.460845] fs/cifs/netmisc.c:map_smb_to_linux_error:891: Mapping smb error code 0xc0000022 to POSIX err -13
[179777.460849] fs/cifs/cifssmb.c:CIFSSMBSetEOF:5469: SetPathInfo (file size) returned -13
[179777.460851] fs/cifs/inode.c:cifs_set_file_size:1934: SetEOF by path (setattrs) rc = -13
[179777.460855] fs/cifs/inode.c:cifs_setattr_nounix:2269: CIFS VFS: leaving cifs_setattr_nounix (xid = 655) rc = -13
[179777.460863] fs/cifs/file.c:cifsFileInfo_put:385: closing last open instance for inode ffff88005a42b828
[179777.460866] fs/cifs/file.c:cifsFileInfo_put:403: CIFS VFS: in cifsFileInfo_put as Xid: 656 with uid: 0
[179777.460869] fs/cifs/cifssmb.c:CIFSSMBClose:2457: In CIFSSMBClose
[179777.460873] fs/cifs/transport.c:AllocMidQEntry:64: For smb_command 4
[179777.460876] fs/cifs/transport.c:smb_send_rqst:288: Sending smb: smb_len=41
[179777.461257] fs/cifs/connect.c:cifs_demultiplex_thread:874: RFC1002 header 0x23
[179777.461267] fs/cifs/misc.c:checkSMB:316: checkSMB Length: 0x27, smb_buf_length: 0x23
[179777.461280] fs/cifs/transport.c:cifs_sync_mid_result:571: cifs_sync_mid_result: cmd=4 mid=22 state=4

We encountered this problem whilst backporting the CIFS driver to a kernel and VFS old enough
to still call inode_operations.setattr() when truncating a file. We're not sure it is the
right upstream solution, but it worked for us on this older kernel.

Cc: Steve French <sfrench@samba.org>
Cc: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Dean Gehnert <deang@tpi.com>
Signed-off-by: Tim Gardner <timg@tpi.com>
---

V3 - same as V2
V2 - There really is no substantive change from V1. Rather, this patch is now
the first in a series that acheives the review comments set out by Jeff Layton
for the V1 patch.

 fs/cifs/cifsproto.h |    3 --
 fs/cifs/cifssmb.c   |   98 ---------------------------------------------------
 fs/cifs/smb1ops.c   |   36 ++++++++++++++++++-
 3 files changed, 35 insertions(+), 102 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index aa33976..fe69b9c 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -296,9 +296,6 @@ extern int CIFSSMBSetAttrLegacy(unsigned int xid, struct cifs_tcon *tcon,
 			char *fileName, __u16 dos_attributes,
 			const struct nls_table *nls_codepage);
 #endif /* possibly unneeded function */
-extern int CIFSSMBSetEOF(const unsigned int xid, struct cifs_tcon *tcon,
-			 const char *file_name, __u64 size,
-			 struct cifs_sb_info *cifs_sb, bool set_allocation);
 extern int CIFSSMBSetFileSize(const unsigned int xid, struct cifs_tcon *tcon,
 			      struct cifsFileInfo *cfile, __u64 size,
 			      bool set_allocation);
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 124aa02..53f1b9b 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -5453,104 +5453,6 @@ QFSPosixRetry:
 	return rc;
 }
 
-
-/*
- * We can not use write of zero bytes trick to set file size due to need for
- * large file support. Also note that this SetPathInfo is preferred to
- * SetFileInfo based method in next routine which is only needed to work around
- * a sharing violation bugin Samba which this routine can run into.
- */
-int
-CIFSSMBSetEOF(const unsigned int xid, struct cifs_tcon *tcon,
-	      const char *file_name, __u64 size, struct cifs_sb_info *cifs_sb,
-	      bool set_allocation)
-{
-	struct smb_com_transaction2_spi_req *pSMB = NULL;
-	struct smb_com_transaction2_spi_rsp *pSMBr = NULL;
-	struct file_end_of_file_info *parm_data;
-	int name_len;
-	int rc = 0;
-	int bytes_returned = 0;
-	int remap = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR;
-
-	__u16 params, byte_count, data_count, param_offset, offset;
-
-	cifs_dbg(FYI, "In SetEOF\n");
-SetEOFRetry:
-	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
-		      (void **) &pSMBr);
-	if (rc)
-		return rc;
-
-	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
-		name_len =
-		    cifsConvertToUTF16((__le16 *) pSMB->FileName, file_name,
-				       PATH_MAX, cifs_sb->local_nls, remap);
-		name_len++;	/* trailing null */
-		name_len *= 2;
-	} else {	/* BB improve the check for buffer overruns BB */
-		name_len = strnlen(file_name, PATH_MAX);
-		name_len++;	/* trailing null */
-		strncpy(pSMB->FileName, file_name, name_len);
-	}
-	params = 6 + name_len;
-	data_count = sizeof(struct file_end_of_file_info);
-	pSMB->MaxParameterCount = cpu_to_le16(2);
-	pSMB->MaxDataCount = cpu_to_le16(4100);
-	pSMB->MaxSetupCount = 0;
-	pSMB->Reserved = 0;
-	pSMB->Flags = 0;
-	pSMB->Timeout = 0;
-	pSMB->Reserved2 = 0;
-	param_offset = offsetof(struct smb_com_transaction2_spi_req,
-				InformationLevel) - 4;
-	offset = param_offset + params;
-	if (set_allocation) {
-		if (tcon->ses->capabilities & CAP_INFOLEVEL_PASSTHRU)
-			pSMB->InformationLevel =
-				cpu_to_le16(SMB_SET_FILE_ALLOCATION_INFO2);
-		else
-			pSMB->InformationLevel =
-				cpu_to_le16(SMB_SET_FILE_ALLOCATION_INFO);
-	} else /* Set File Size */  {
-	    if (tcon->ses->capabilities & CAP_INFOLEVEL_PASSTHRU)
-		    pSMB->InformationLevel =
-				cpu_to_le16(SMB_SET_FILE_END_OF_FILE_INFO2);
-	    else
-		    pSMB->InformationLevel =
-				cpu_to_le16(SMB_SET_FILE_END_OF_FILE_INFO);
-	}
-
-	parm_data =
-	    (struct file_end_of_file_info *) (((char *) &pSMB->hdr.Protocol) +
-				       offset);
-	pSMB->ParameterOffset = cpu_to_le16(param_offset);
-	pSMB->DataOffset = cpu_to_le16(offset);
-	pSMB->SetupCount = 1;
-	pSMB->Reserved3 = 0;
-	pSMB->SubCommand = cpu_to_le16(TRANS2_SET_PATH_INFORMATION);
-	byte_count = 3 /* pad */  + params + data_count;
-	pSMB->DataCount = cpu_to_le16(data_count);
-	pSMB->TotalDataCount = pSMB->DataCount;
-	pSMB->ParameterCount = cpu_to_le16(params);
-	pSMB->TotalParameterCount = pSMB->ParameterCount;
-	pSMB->Reserved4 = 0;
-	inc_rfc1001_len(pSMB, byte_count);
-	parm_data->FileSize = cpu_to_le64(size);
-	pSMB->ByteCount = cpu_to_le16(byte_count);
-	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
-			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
-	if (rc)
-		cifs_dbg(FYI, "SetPathInfo (file size) returned %d\n", rc);
-
-	cifs_buf_release(pSMB);
-
-	if (rc == -EAGAIN)
-		goto SetEOFRetry;
-
-	return rc;
-}
-
 int
 CIFSSMBSetFileSize(const unsigned int xid, struct cifs_tcon *tcon,
 		   struct cifsFileInfo *cfile, __u64 size, bool set_allocation)
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 5f5ba0d..14d4832 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -756,6 +756,40 @@ cifs_sync_write(const unsigned int xid, struct cifsFileInfo *cfile,
 }
 
 static int
+smb_set_file_size(const unsigned int xid, struct cifs_tcon *tcon,
+	      const char *full_path, __u64 size, struct cifs_sb_info *cifs_sb,
+	      bool set_allocation)
+{
+	int oplock = 0;
+	int rc;
+	__u16 netfid;
+	struct cifsFileInfo cfile;
+
+	cifs_dbg(FYI, "smb_set_file_size: %s\n", full_path);
+
+	rc = CIFSSMBOpen(xid, tcon, full_path, FILE_OPEN,
+			 FILE_WRITE_DATA, CREATE_NOT_DIR,
+			 &netfid, &oplock, NULL, cifs_sb->local_nls,
+			 cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+	if (rc)
+		return rc;
+
+	/*
+	 * Only 2 fields are required to set the file size.
+	 */
+	memset(&cfile, 0, sizeof(cfile));
+	cfile.pid = current->tgid;
+	cfile.fid.netfid = netfid;
+
+	rc = CIFSSMBSetFileSize(xid, tcon, &cfile, size, set_allocation);
+
+	if (!rc)
+		rc = CIFSSMBClose(xid, tcon, netfid);
+
+	return rc;
+}
+
+static int
 smb_set_file_info(struct inode *inode, const char *full_path,
 		  FILE_BASIC_INFO *buf, const unsigned int xid)
 {
@@ -979,7 +1013,7 @@ struct smb_version_operations smb1_operations = {
 	.query_path_info = cifs_query_path_info,
 	.query_file_info = cifs_query_file_info,
 	.get_srv_inum = cifs_get_srv_inum,
-	.set_path_size = CIFSSMBSetEOF,
+	.set_path_size = smb_set_file_size,
 	.set_file_size = CIFSSMBSetFileSize,
 	.set_file_info = smb_set_file_info,
 	.set_compression = cifs_set_compression,
-- 
1.7.9.5
