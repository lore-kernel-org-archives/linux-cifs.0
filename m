From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 3/6] CIFS: implement get_dfs_refer for SMB2+
Date: Thu, 23 Feb 2017 17:06:23 -0800
Message-ID: <CAKywueSCHszmzBbfLfJTP66=w6FcKgR2p1UJJig4uxcgC4QSfA@mail.gmail.com>
References: <20170223144334.22320-1-aaptel@suse.com> <20170223144334.22320-4-aaptel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170223144334.22320-4-aaptel-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2017-02-23 6:43 GMT-08:00 Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>:
> Signed-off-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
> ---
>  fs/cifs/smb2ops.c | 72 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/cifs/smb2pdu.h |  8 +++++++
>  2 files changed, 80 insertions(+)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index a44b4db..2563fe8 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -1097,6 +1097,78 @@ smb2_new_lease_key(struct cifs_fid *fid)
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
> +       int rc = -EINVAL;
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
> +       tcon = list_first_entry(&ses->tcon_list, struct cifs_tcon, tcon_list);
> +       if (!tcon)
> +               goto out;

Accessing the tcon_list should be protected by spin_locks and also a
reference to the tcon should be acquired before using it safely.

Also you can extend SMB2_ioctl argument list to allow passing ipc_tid.
In this case SMB2_ioctl() can choose what to use - ipc_tid or tcon; if
tcon is passed -use it, otherwise - use ipc_tid.

In this case you can fallback to ipc_tid if no tcon is found in the list.

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
> +               rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
> +                               FSCTL_DFS_GET_REFERRALS, true /* is_fsctl */,
> +                               (char *)dfs_req, dfs_req_size,
> +                               (char **)&dfs_rsp, &dfs_rsp_size);
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
> +       kfree(utf16_path);
> +       kfree(dfs_req);
> +       kfree(dfs_rsp);
> +       return rc;
> +}
>  #define SMB2_SYMLINK_STRUCT_SIZE \
>         (sizeof(struct smb2_err_rsp) - 1 + sizeof(struct smb2_symlink_err_rsp))
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



-- 
Best regards,
Pavel Shilovsky
