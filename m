From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 7/7] CIFS: implement get_dfs_refer for SMB2+
Date: Tue, 28 Feb 2017 18:42:54 -0800
Message-ID: <CAKywueTun2cOA6yHmwRNXTXEjCdubO9BN=S67egmQ+zumaJEbw@mail.gmail.com>
References: <20170228184034.18771-1-aaptel@suse.com> <20170228184034.18771-8-aaptel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170228184034.18771-8-aaptel-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2017-02-28 10:40 GMT-08:00 Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>:
> in SMB2+ the get_dfs_refer operation uses a FSCTL. The request can be
> made on any Tree Connection according to the specs. Since Samba only
> accepted it on an IPC connection until recently, try that first.
>
> https://lists.samba.org/archive/samba-technical/2017-February/118859.html
>
> 3.2.4.20.3 Application Requests DFS Referral Information:
>> The client MUST search for an existing Session and TreeConnect to any
>> share on the server identified by ServerName for the user identified by
>> UserCredentials. If no Session and TreeConnect are found, the client
>> MUST establish a new Session and TreeConnect to IPC$ on the target
>> server as described in section 3.2.4.2 using the supplied ServerName and
>> UserCredentials.
>
> Signed-off-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
> ---
>  fs/cifs/smb2ops.c | 100 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/cifs/smb2pdu.h |   8 +++++
>  2 files changed, 108 insertions(+)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 02937cc..fcd524d 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -1104,6 +1104,102 @@ smb2_new_lease_key(struct cifs_fid *fid)
>         generate_random_uuid(fid->lease_key);
>  }
>
> +static int
> +smb2_get_dfs_refer(const unsigned int xid, struct cifs_ses *ses,
> +                  const char *search_name,
> +                  struct dfs_info3_param **target_nodes,
> +                  unsigned int *num_of_nodes,
> +                  const struct nls_table *nls_codepage, int remap)
> +{
> +       int rc;
> +       __le16 *utf16_path = NULL;
> +       int utf16_path_len = 0;
> +       struct cifs_tcon *tcon;
> +       struct fsctl_get_dfs_referral_req *dfs_req = NULL;
> +       struct get_dfs_referral_rsp *dfs_rsp = NULL;
> +       u32 dfs_req_size = 0, dfs_rsp_size = 0;
> +
> +       cifs_dbg(FYI, "smb2_get_dfs_refer path <%s>\n", search_name);
> +
> +       /*
> +        * Use any tcon from the current session. Here, the first one.
> +        */
> +       spin_lock(&cifs_tcp_ses_lock);
> +       tcon = list_first_entry_or_null(&ses->tcon_list, struct cifs_tcon, tcon_list);
> +       if (tcon)
> +               tcon->tc_count++;
> +       spin_unlock(&cifs_tcp_ses_lock);
> +
> +       if (!tcon) {
> +               cifs_dbg(VFS, "session %p has no tcon available for a dfs referral request\n",
> +                        ses);
> +               rc = -ENOTCONN;
> +               goto out;
> +       }
> +
> +       utf16_path = cifs_strndup_to_utf16(search_name, PATH_MAX,
> +                                          &utf16_path_len,
> +                                          nls_codepage, remap);
> +       if (!utf16_path) {
> +               rc = -ENOMEM;
> +               goto out;
> +       }
> +
> +       dfs_req_size = sizeof(*dfs_req) + utf16_path_len;
> +       dfs_req = kzalloc(dfs_req_size, GFP_KERNEL);
> +       if (!dfs_req) {
> +               rc = -ENOMEM;
> +               goto out;
> +       }
> +
> +       /* Highest DFS referral version understood */
> +       dfs_req->MaxReferralLevel = cpu_to_le16(DFS_VERSION);
> +
> +       /* Path to resolve in an UTF-16 null-terminated string */
> +       memcpy(dfs_req->RequestFileName, utf16_path, utf16_path_len);
> +
> +       do {
> +               /* try first with IPC */
> +               rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
> +                               FSCTL_DFS_GET_REFERRALS,
> +                               true /* is_fsctl */, true /* use_ipc */,
> +                               (char *)dfs_req, dfs_req_size,
> +                               (char **)&dfs_rsp, &dfs_rsp_size);
> +               if (rc == -ENOTCONN) {
> +                       /* try with normal tcon */
> +                       rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
> +                                       FSCTL_DFS_GET_REFERRALS,
> +                                       true /* is_fsctl */, false /*use_ipc*/,
> +                                       (char *)dfs_req, dfs_req_size,
> +                                       (char **)&dfs_rsp, &dfs_rsp_size);
> +               }
> +       } while (rc == -EAGAIN);
> +
> +       if (rc) {
> +               cifs_dbg(VFS, "ioctl error in smb2_get_dfs_refer rc=%d\n", rc);
> +               goto out;
> +       }
> +
> +       rc = parse_dfs_referrals(dfs_rsp, dfs_rsp_size,
> +                                num_of_nodes, target_nodes,
> +                                nls_codepage, remap, search_name,
> +                                true /* is_unicode */);
> +       if (rc) {
> +               cifs_dbg(VFS, "parse error in smb2_get_dfs_refer rc=%d\n", rc);
> +               goto out;
> +       }
> +
> + out:
> +       if (tcon) {
> +               spin_lock(&cifs_tcp_ses_lock);
> +               tcon->tc_count--;
> +               spin_unlock(&cifs_tcp_ses_lock);
> +       }
> +       kfree(utf16_path);
> +       kfree(dfs_req);
> +       kfree(dfs_rsp);
> +       return rc;
> +}
>  #define SMB2_SYMLINK_STRUCT_SIZE \
>         (sizeof(struct smb2_err_rsp) - 1 + sizeof(struct smb2_symlink_err_rsp))
>
> @@ -2263,6 +2359,7 @@ struct smb_version_operations smb20_operations = {
>         .clone_range = smb2_clone_range,
>         .wp_retry_size = smb2_wp_retry_size,
>         .dir_needs_close = smb2_dir_needs_close,
> +       .get_dfs_refer = smb2_get_dfs_refer,
>  };
>
>  struct smb_version_operations smb21_operations = {
> @@ -2344,6 +2441,7 @@ struct smb_version_operations smb21_operations = {
>         .wp_retry_size = smb2_wp_retry_size,
>         .dir_needs_close = smb2_dir_needs_close,
>         .enum_snapshots = smb3_enum_snapshots,
> +       .get_dfs_refer = smb2_get_dfs_refer,
>  };
>
>  struct smb_version_operations smb30_operations = {
> @@ -2435,6 +2533,7 @@ struct smb_version_operations smb30_operations = {
>         .free_transform_rq = smb3_free_transform_rq,
>         .is_transform_hdr = smb3_is_transform_hdr,
>         .receive_transform = smb3_receive_transform,
> +       .get_dfs_refer = smb2_get_dfs_refer,
>  };
>
>  #ifdef CONFIG_CIFS_SMB311
> @@ -2527,6 +2626,7 @@ struct smb_version_operations smb311_operations = {
>         .free_transform_rq = smb3_free_transform_rq,
>         .is_transform_hdr = smb3_is_transform_hdr,
>         .receive_transform = smb3_receive_transform,
> +       .get_dfs_refer = smb2_get_dfs_refer,
>  };
>  #endif /* CIFS_SMB311 */
>
> diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
> index c03b252..18700fd 100644
> --- a/fs/cifs/smb2pdu.h
> +++ b/fs/cifs/smb2pdu.h
> @@ -695,6 +695,14 @@ struct fsctl_get_integrity_information_rsp {
>  /* Integrity flags for above */
>  #define FSCTL_INTEGRITY_FLAG_CHECKSUM_ENFORCEMENT_OFF  0x00000001
>
> +/* See MS-DFSC 2.2.2 */
> +struct fsctl_get_dfs_referral_req {
> +       __le16 MaxReferralLevel;
> +       __u8 RequestFileName[];
> +} __packed;
> +
> +/* DFS response is struct get_dfs_refer_rsp */
> +
>  /* See MS-SMB2 2.2.31.3 */
>  struct network_resiliency_req {
>         __le32 Timeout;
> --
> 2.10.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

-- 
Best regards,
Pavel Shilovsky
