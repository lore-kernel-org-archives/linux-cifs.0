From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [cifs:for-next 7/7] fs/cifs/smb2pdu.c:2056
 smb311_posix_mkdir() error: uninitialized symbol 'rsp'.
Date: Fri, 22 Jun 2018 14:02:08 +0300
Message-ID: <20180622110208.2357dadqw6vj3j56@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
 samba-technical@lists.samba.org, Paulo Alcantara <palcantara@suse.de>,
 kbuild-all@01.org, Steve French <stfrench@microsoft.com>
To: kbuild@01.org, Aurelien Aptel <aaptel@suse.com>
Return-path: <kbuild-bounces@lists.01.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.01.org/mailman/options/kbuild>,
 <mailto:kbuild-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/kbuild/>
List-Post: <mailto:kbuild@lists.01.org>
List-Help: <mailto:kbuild-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/kbuild>,
 <mailto:kbuild-request@lists.01.org?subject=subscribe>
Errors-To: kbuild-bounces@lists.01.org
Sender: "kbuild" <kbuild-bounces@lists.01.org>
List-Id: linux-cifs.vger.kernel.org

tree:   git://git.samba.org/sfrench/cifs-2.6.git for-next
head:   a0b287ee23a7ad77c1222301f7550625ca2e0d3b
commit: a0b287ee23a7ad77c1222301f7550625ca2e0d3b [7/7] CIFS: fix memory leak and remove dead code

smatch warnings:
fs/cifs/smb2pdu.c:2056 smb311_posix_mkdir() error: uninitialized symbol 'rsp'.

git remote add cifs git://git.samba.org/sfrench/cifs-2.6.git
git remote update cifs
git checkout a0b287ee23a7ad77c1222301f7550625ca2e0d3b
vim +/rsp +2056 fs/cifs/smb2pdu.c

f0712928 Aurelien Aptel 2017-02-22  1913  
bea851b8 Steve French   2018-06-14  1914  #ifdef CONFIG_CIFS_SMB311
bea851b8 Steve French   2018-06-14  1915  int smb311_posix_mkdir(const unsigned int xid, struct inode *inode,
bea851b8 Steve French   2018-06-14  1916  			       umode_t mode, struct cifs_tcon *tcon,
bea851b8 Steve French   2018-06-14  1917  			       const char *full_path,
bea851b8 Steve French   2018-06-14  1918  			       struct cifs_sb_info *cifs_sb)
bea851b8 Steve French   2018-06-14  1919  {
bea851b8 Steve French   2018-06-14  1920  	struct smb_rqst rqst;
bea851b8 Steve French   2018-06-14  1921  	struct smb2_create_req *req;
bea851b8 Steve French   2018-06-14  1922  	struct smb2_create_rsp *rsp;
bea851b8 Steve French   2018-06-14  1923  	struct TCP_Server_Info *server;
bea851b8 Steve French   2018-06-14  1924  	struct cifs_ses *ses = tcon->ses;
bea851b8 Steve French   2018-06-14  1925  	struct kvec iov[3]; /* make sure at least one for each open context */
bea851b8 Steve French   2018-06-14  1926  	struct kvec rsp_iov = {NULL, 0};
bea851b8 Steve French   2018-06-14  1927  	int resp_buftype;
bea851b8 Steve French   2018-06-14  1928  	int uni_path_len;
bea851b8 Steve French   2018-06-14  1929  	__le16 *copy_path = NULL;
bea851b8 Steve French   2018-06-14  1930  	int copy_size;
bea851b8 Steve French   2018-06-14  1931  	int rc = 0;
bea851b8 Steve French   2018-06-14  1932  	unsigned int n_iov = 2;
bea851b8 Steve French   2018-06-14  1933  	__u32 file_attributes = 0;
bea851b8 Steve French   2018-06-14  1934  	char *pc_buf = NULL;
bea851b8 Steve French   2018-06-14  1935  	int flags = 0;
bea851b8 Steve French   2018-06-14  1936  	unsigned int total_len;
a0b287ee Aurelien Aptel 2018-06-19  1937  	__le16 *utf16_path = NULL;
bea851b8 Steve French   2018-06-14  1938  
bea851b8 Steve French   2018-06-14  1939  	cifs_dbg(FYI, "mkdir\n");
bea851b8 Steve French   2018-06-14  1940  
a0b287ee Aurelien Aptel 2018-06-19  1941  	/* resource #1: path allocation */
a0b287ee Aurelien Aptel 2018-06-19  1942  	utf16_path = cifs_convert_path_to_utf16(full_path, cifs_sb);
a0b287ee Aurelien Aptel 2018-06-19  1943  	if (!utf16_path)
a0b287ee Aurelien Aptel 2018-06-19  1944  		return -ENOMEM;
a0b287ee Aurelien Aptel 2018-06-19  1945  
bea851b8 Steve French   2018-06-14  1946  	if (ses && (ses->server))
bea851b8 Steve French   2018-06-14  1947  		server = ses->server;
a0b287ee Aurelien Aptel 2018-06-19  1948  	else {
a0b287ee Aurelien Aptel 2018-06-19  1949  		rc = -EIO;
a0b287ee Aurelien Aptel 2018-06-19  1950  		goto err_free_path;
a0b287ee Aurelien Aptel 2018-06-19  1951  	}
bea851b8 Steve French   2018-06-14  1952  
a0b287ee Aurelien Aptel 2018-06-19  1953  	/* resource #2: request */
bea851b8 Steve French   2018-06-14  1954  	rc = smb2_plain_req_init(SMB2_CREATE, tcon, (void **) &req, &total_len);
bea851b8 Steve French   2018-06-14  1955  	if (rc)
a0b287ee Aurelien Aptel 2018-06-19  1956  		goto err_free_path;
a0b287ee Aurelien Aptel 2018-06-19  1957  
bea851b8 Steve French   2018-06-14  1958  
bea851b8 Steve French   2018-06-14  1959  	if (smb3_encryption_required(tcon))
bea851b8 Steve French   2018-06-14  1960  		flags |= CIFS_TRANSFORM_REQ;
bea851b8 Steve French   2018-06-14  1961  
bea851b8 Steve French   2018-06-14  1962  	req->ImpersonationLevel = IL_IMPERSONATION;
bea851b8 Steve French   2018-06-14  1963  	req->DesiredAccess = cpu_to_le32(FILE_WRITE_ATTRIBUTES);
bea851b8 Steve French   2018-06-14  1964  	/* File attributes ignored on open (used in create though) */
bea851b8 Steve French   2018-06-14  1965  	req->FileAttributes = cpu_to_le32(file_attributes);
bea851b8 Steve French   2018-06-14  1966  	req->ShareAccess = FILE_SHARE_ALL_LE;
bea851b8 Steve French   2018-06-14  1967  	req->CreateDisposition = cpu_to_le32(FILE_CREATE);
bea851b8 Steve French   2018-06-14  1968  	req->CreateOptions = cpu_to_le32(CREATE_NOT_FILE);
bea851b8 Steve French   2018-06-14  1969  
bea851b8 Steve French   2018-06-14  1970  	iov[0].iov_base = (char *)req;
bea851b8 Steve French   2018-06-14  1971  	/* -1 since last byte is buf[0] which is sent below (path) */
bea851b8 Steve French   2018-06-14  1972  	iov[0].iov_len = total_len - 1;
bea851b8 Steve French   2018-06-14  1973  
bea851b8 Steve French   2018-06-14  1974  	req->NameOffset = cpu_to_le16(sizeof(struct smb2_create_req));
bea851b8 Steve French   2018-06-14  1975  
bea851b8 Steve French   2018-06-14  1976  	/* [MS-SMB2] 2.2.13 NameOffset:
bea851b8 Steve French   2018-06-14  1977  	 * If SMB2_FLAGS_DFS_OPERATIONS is set in the Flags field of
bea851b8 Steve French   2018-06-14  1978  	 * the SMB2 header, the file name includes a prefix that will
bea851b8 Steve French   2018-06-14  1979  	 * be processed during DFS name normalization as specified in
bea851b8 Steve French   2018-06-14  1980  	 * section 3.3.5.9. Otherwise, the file name is relative to
bea851b8 Steve French   2018-06-14  1981  	 * the share that is identified by the TreeId in the SMB2
bea851b8 Steve French   2018-06-14  1982  	 * header.
bea851b8 Steve French   2018-06-14  1983  	 */
bea851b8 Steve French   2018-06-14  1984  	if (tcon->share_flags & SHI1005_FLAGS_DFS) {
bea851b8 Steve French   2018-06-14  1985  		int name_len;
bea851b8 Steve French   2018-06-14  1986  
bea851b8 Steve French   2018-06-14  1987  		req->sync_hdr.Flags |= SMB2_FLAGS_DFS_OPERATIONS;
bea851b8 Steve French   2018-06-14  1988  		rc = alloc_path_with_tree_prefix(&copy_path, &copy_size,
bea851b8 Steve French   2018-06-14  1989  						 &name_len,
a0b287ee Aurelien Aptel 2018-06-19  1990  						 tcon->treeName, utf16_path);
a0b287ee Aurelien Aptel 2018-06-19  1991  		if (rc)
a0b287ee Aurelien Aptel 2018-06-19  1992  			goto err_free_req;
a0b287ee Aurelien Aptel 2018-06-19  1993  
bea851b8 Steve French   2018-06-14  1994  		req->NameLength = cpu_to_le16(name_len * 2);
bea851b8 Steve French   2018-06-14  1995  		uni_path_len = copy_size;
a0b287ee Aurelien Aptel 2018-06-19  1996  		/* free before overwriting resource */
a0b287ee Aurelien Aptel 2018-06-19  1997  		kfree(utf16_path);
a0b287ee Aurelien Aptel 2018-06-19  1998  		utf16_path = copy_path;
bea851b8 Steve French   2018-06-14  1999  	} else {
a0b287ee Aurelien Aptel 2018-06-19  2000  		uni_path_len = (2 * UniStrnlen((wchar_t *)utf16_path, PATH_MAX)) + 2;
bea851b8 Steve French   2018-06-14  2001  		/* MUST set path len (NameLength) to 0 opening root of share */
bea851b8 Steve French   2018-06-14  2002  		req->NameLength = cpu_to_le16(uni_path_len - 2);
bea851b8 Steve French   2018-06-14  2003  		if (uni_path_len % 8 != 0) {
bea851b8 Steve French   2018-06-14  2004  			copy_size = roundup(uni_path_len, 8);
bea851b8 Steve French   2018-06-14  2005  			copy_path = kzalloc(copy_size, GFP_KERNEL);
bea851b8 Steve French   2018-06-14  2006  			if (!copy_path) {
a0b287ee Aurelien Aptel 2018-06-19  2007  				rc = -ENOMEM;
a0b287ee Aurelien Aptel 2018-06-19  2008  				goto err_free_req;
bea851b8 Steve French   2018-06-14  2009  			}
a0b287ee Aurelien Aptel 2018-06-19  2010  			memcpy((char *)copy_path, (const char *)utf16_path,
bea851b8 Steve French   2018-06-14  2011  			       uni_path_len);
bea851b8 Steve French   2018-06-14  2012  			uni_path_len = copy_size;
a0b287ee Aurelien Aptel 2018-06-19  2013  			/* free before overwriting resource */
a0b287ee Aurelien Aptel 2018-06-19  2014  			kfree(utf16_path);
a0b287ee Aurelien Aptel 2018-06-19  2015  			utf16_path = copy_path;
bea851b8 Steve French   2018-06-14  2016  		}
bea851b8 Steve French   2018-06-14  2017  	}
bea851b8 Steve French   2018-06-14  2018  
bea851b8 Steve French   2018-06-14  2019  	iov[1].iov_len = uni_path_len;
a0b287ee Aurelien Aptel 2018-06-19  2020  	iov[1].iov_base = utf16_path;
bea851b8 Steve French   2018-06-14  2021  	req->RequestedOplockLevel = SMB2_OPLOCK_LEVEL_NONE;
bea851b8 Steve French   2018-06-14  2022  
bea851b8 Steve French   2018-06-14  2023  	if (tcon->posix_extensions) {
a0b287ee Aurelien Aptel 2018-06-19  2024  		/* resource #3: posix buf */
bea851b8 Steve French   2018-06-14  2025  		rc = add_posix_context(iov, &n_iov, mode);
a0b287ee Aurelien Aptel 2018-06-19  2026  		if (rc)
a0b287ee Aurelien Aptel 2018-06-19  2027  			goto err_free_req;
bea851b8 Steve French   2018-06-14  2028  		pc_buf = iov[n_iov-1].iov_base;
bea851b8 Steve French   2018-06-14  2029  	}
bea851b8 Steve French   2018-06-14  2030  
bea851b8 Steve French   2018-06-14  2031  
bea851b8 Steve French   2018-06-14  2032  	memset(&rqst, 0, sizeof(struct smb_rqst));
bea851b8 Steve French   2018-06-14  2033  	rqst.rq_iov = iov;
bea851b8 Steve French   2018-06-14  2034  	rqst.rq_nvec = n_iov;
bea851b8 Steve French   2018-06-14  2035  
a0b287ee Aurelien Aptel 2018-06-19  2036  	/* resource #4: response buffer */
a0b287ee Aurelien Aptel 2018-06-19  2037  	rc = cifs_send_recv(xid, ses, &rqst, &resp_buftype, flags, &rsp_iov);
a0b287ee Aurelien Aptel 2018-06-19  2038  	if (rc) {
bea851b8 Steve French   2018-06-14  2039  		cifs_stats_fail_inc(tcon, SMB2_CREATE_HE);
bea851b8 Steve French   2018-06-14  2040  		trace_smb3_posix_mkdir_err(xid, tcon->tid, ses->Suid,
a0b287ee Aurelien Aptel 2018-06-19  2041  					   CREATE_NOT_FILE,
a0b287ee Aurelien Aptel 2018-06-19  2042  					   FILE_WRITE_ATTRIBUTES, rc);
a0b287ee Aurelien Aptel 2018-06-19  2043  		goto err_free_rsp_buf;
                                                        ^^^^^^^^^^^^^^^^^^^^^^
a0b287ee Aurelien Aptel 2018-06-19  2044  	}
a0b287ee Aurelien Aptel 2018-06-19  2045  
a0b287ee Aurelien Aptel 2018-06-19  2046  	rsp = (struct smb2_create_rsp *)rsp_iov.iov_base;
                                                ^^^^^^
Initialized too late.

bea851b8 Steve French   2018-06-14  2047  	trace_smb3_posix_mkdir_done(xid, rsp->PersistentFileId, tcon->tid,
bea851b8 Steve French   2018-06-14  2048  				    ses->Suid, CREATE_NOT_FILE,
bea851b8 Steve French   2018-06-14  2049  				    FILE_WRITE_ATTRIBUTES);
bea851b8 Steve French   2018-06-14  2050  
bea851b8 Steve French   2018-06-14  2051  	SMB2_close(xid, tcon, rsp->PersistentFileId, rsp->VolatileFileId);
bea851b8 Steve French   2018-06-14  2052  
bea851b8 Steve French   2018-06-14  2053  	/* Eventually save off posix specific response info and timestaps */
bea851b8 Steve French   2018-06-14  2054  
a0b287ee Aurelien Aptel 2018-06-19  2055  err_free_rsp_buf:
bea851b8 Steve French   2018-06-14 @2056  	free_rsp_buf(resp_buftype, rsp);
a0b287ee Aurelien Aptel 2018-06-19  2057  	kfree(pc_buf);
a0b287ee Aurelien Aptel 2018-06-19  2058  err_free_req:
a0b287ee Aurelien Aptel 2018-06-19  2059  	cifs_small_buf_release(req);
a0b287ee Aurelien Aptel 2018-06-19  2060  err_free_path:
a0b287ee Aurelien Aptel 2018-06-19  2061  	kfree(utf16_path);
bea851b8 Steve French   2018-06-14  2062  	return rc;
bea851b8 Steve French   2018-06-14  2063  }
bea851b8 Steve French   2018-06-14  2064  #endif /* SMB311 */
bea851b8 Steve French   2018-06-14  2065  

:::::: The code at line 2056 was first introduced by commit
:::::: bea851b8babe6c87c36e97c9de0dd0bea0dd5802 smb3: Fix mode on mkdir on smb311 mounts

:::::: TO: Steve French <stfrench@microsoft.com>
:::::: CC: Steve French <stfrench@microsoft.com>
