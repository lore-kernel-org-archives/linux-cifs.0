From: Steve French <smfrench@gmail.com>
Subject: Samba ioctls - what we implement and should implement in the future
Date: Mon, 30 Sep 2013 22:22:52 -0500
Message-ID: <CAH2r5mvyYLQPE8+a6ww7L94Tr-v3YyyC2=CCwVq+bhaXr7Eb5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: samba-technical <samba-technical@lists.samba.org>,
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Return-path: <samba-technical-bounces@lists.samba.org>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

In talking with the Microsoft FVT test tools team, I realized that we
need a list of which IOCTLS/FSCTLS we implement and which ones we
should be investigating for the future.   I scanned through Samba
master over the weekend to see what we implement.  See below.  NB: I
use the term ioctl and fsctl loosely (technically these are all
fsctls).   Since some of these fsctls are self-contained, somewhat
independent of large side effects across the server (even though many
would require adding a Samba VFS extensions since quite a few would be
btrfs, GPFS, gluster or other fs specific).

We implement the following file system ioctls:
FSCTL_SET_SPARSE (fs dependent)
FSCTL_CREATE_OR_GET_OBJECT_ID
FSCTL_GET_SHADOW_COPY_DATA (file system dependent)
FSCTL_FIND_FILES_BY_SID
FSCTL_QUERY_ALLOCATED_RANGES

We also implement the following ioctls for SMB2, or in some cases SMB3 or later:
FSCTL_DFS_GET_REFERRALS
FSCTL_PIPE_TRANSCEIVE
FSCTL_PIPE_PEEK
FSCTL_PIPE_WAIT
FSCTL_SRV_COPYCHUNK
FSCTL_VALIDATE_NEGOTIATE_INFO
FSCTL_SRV_REQUEST_RESUME_KEY

David D. is in process of implementing:
FSCTL_GET_COMPRESSION
FSCTL_SET_COMPRESSION


We are strongly interested in investigating and implementing the
following SMB3 server fsctls
FSCTL_SRV_ENUMERATE_SNAPSHOTS
FSCTL_QUERY_NETWORK_INTERFACE_INFO
FSCTL_OFFLOAD_READ
FSCTL_OFFLOAD_WRITE
FSCTL_QUERY_FILE_REGIONS
FSCTL_RECALL_FILE
FSCTL_SET_ENCRYPTION
FSCTL_SET_INTEGRITY_INFORMATION
FSCTL_SET_ZERO_DATA
FSCTL_SET_ZERO_ON_DEALLOCATION
FSCTL_SIS_COPYFILE


We do not implement the following DFS SMB2/SMB3 server fsctls (are any
of the following critical for us to implement).
FSCTL_SRV_READ_HASH
FSCTL_SRV_COPYCHUNK_WRITE
FSCTL_LMR_REQUEST_RESILIENCY
FSCTL_SET_REPARSE_POINT
FSCTL_DFS_GET_REFERRALS_EX
FSCTL_FILE_LEVEL_TRIM
FSCTL_GET_INTEGRITY_INFORMATION
FSCTL_DELETE_OBJECT_ID
FSCTL_DELETE_REPARSE_POINT
FSCTL_FILESYSTEM_GET_STATISTICS
FSCTL_GET_NTFS_VOLUME_DATA
FSCTL_GET_REFS_VOLUME_DATA
FSCTL_GET_REPARSE_POINT
FSCTL_GET_RETRIEVAL_POINTERS
FSCTL_IS_PATHNAME_VALID
FSCTL_LMR_SET_LINK_TRACKING_INFORMATION
FSCTL_QUERY_FAT_BPB
FSCTL_QUERY_ON_DISK_VOLUME_INFO
FSCTL_QUERY_SPARING_INFO
FSCTL_READ_FILE_USN_DATA
FSCTL_SET_DEFECT_MANAGEMENT
FSCTL_SET_OBJECT_ID
FSCTL_SET_OBJECT_ID_EXTENDED
FSCTL_SET_REPARSE_POINT
FSCTL_WRITE_USN_CLOSE_RECORD




Additional details

FSCTLs Implemented in Samba VFS (CIFS and SMB2/SMB3)
FSCTL_SET_SPARSE (fs dependent, see file_set_sparse)
FSCTL_CREATE_OR_GET_OBJECT_ID
FSCTL_GET_SHADOW_COPY_DATA (file system dependent)
FSCTL_FIND_FILES_BY_SID (Metze had some implementation questions)
FSCTL_QUERY_ALLOCATED_RANGES

SMB2 specific fsctls in 4 categories
    FSCTL_DFS category:
        FSCTL_DFS_GET_REFERRALS  (see smb2_ioctl_dfs(in_ctl_code, ev,
req, state);)


    FSCTL_FILESYSTEM category: see smb2_ioctl_filesys()
        None (all passed to VFS).  See above.


    FSCTL_NAMED_PIPE category: see smb2_ioctl_named_pipe()
        FSCTL_PIPE_TRANSCEIVE

    FSCTL_NETWORK_FILESYSTEM category: see smb2_ioctl_network_fs()
        FSCTL_SRV_COPYCHUNK:
            see fsctl_srv_copychunk_send(state, ev, state->fsp,
                          &state->in_input,
                          state->in_max_output,
                          state->smb2req);
        FSCTL_VALIDATE_NEGOTIATE_INFO:
            see fsctl_validate_neg_info(state, ev,
                         state->smbreq->sconn->conn,
                         &state->in_input,
                         state->in_max_output,
                         &state->out_output,
                         &state->disconnect);

        FSCTL_SRV_REQUEST_RESUME_KEY:
            see fsctl_srv_req_resume_key(state, ev, state->fsp,
                          state->in_max_output,
                          &state->out_output);


Stubs
--------
FSCTL_GET_REPARSE_POINT - always returns error, not a reparse point
FSCTL_SET_REPARSE_POINT - always returns error

FSCTL_IS_VOLUME_DIRTY - always returns an error since this apparently
is not a valid remoteable FSCTL

-- 
Thanks,

Steve
