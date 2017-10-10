From: Nico Kadel-Garcia <nkadel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Fix bool initialization/comparison
Date: Mon, 9 Oct 2017 21:14:31 -0400
Message-ID: <CAOCN9ryCju2kXgDy+o6QhdyevaD5tMuWFn9XQW9Ue2jsj_qLZQ@mail.gmail.com>
References: <1507383097081-778026979-0-diffsplit-thomas@m3y3r.de> <1507383097083-1243109004-5-diffsplit-thomas@m3y3r.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        "samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Meyer <thomas-VsYtu1Qij5c@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1507383097083-1243109004-5-diffsplit-thomas-VsYtu1Qij5c@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, Oct 7, 2017 at 10:02 AM, Thomas Meyer via samba-technical
<samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org> wrote:
> Bool initializations should use true and false. Bool tests don't need
> comparisons.

Except that "==" is not a pure boolean check. It's a value check, and
unless these values are defined *very* carefully they may be set to
non-boolean values.

You may be write on these specific checks that they are, in fact,
booleans. But I'd be be cautious about stripping out such checks as a
matter of style.


> Signed-off-by: Thomas Meyer <thomas-VsYtu1Qij5c@public.gmane.org>
> ---
>
> diff -u -p a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -370,7 +370,7 @@ sid_to_id(struct cifs_sb_info *cifs_sb,
>                 else
>                         is_group = false;
>
> -               if (is_well_known_sid(psid, &unix_id, is_group) == false)
> +               if (!is_well_known_sid(psid, &unix_id, is_group))
>                         goto try_upcall_to_get_id;
>
>                 if (is_group) {
> diff -u -p a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -4508,7 +4508,7 @@ findFirstRetry:
>                                 psrch_inf->unicode = false;
>
>                         psrch_inf->ntwrk_buf_start = (char *)pSMBr;
> -                       psrch_inf->smallBuf = 0;
> +                       psrch_inf->smallBuf = false;
>                         psrch_inf->srch_entries_start =
>                                 (char *) &pSMBr->hdr.Protocol +
>                                         le16_to_cpu(pSMBr->t2.DataOffset);
> @@ -4642,7 +4642,7 @@ int CIFSFindNext(const unsigned int xid,
>                                 cifs_buf_release(psrch_inf->ntwrk_buf_start);
>                         psrch_inf->srch_entries_start = response_data;
>                         psrch_inf->ntwrk_buf_start = (char *)pSMB;
> -                       psrch_inf->smallBuf = 0;
> +                       psrch_inf->smallBuf = false;
>                         if (parms->EndofSearch)
>                                 psrch_inf->endOfSearch = true;
>                         else
> diff -u -p a/fs/cifs/connect.c b/fs/cifs/connect.c
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1081,7 +1081,7 @@ static int cifs_parse_security_flavors(c
>                 break;
>  #endif
>         case Opt_sec_none:
> -               vol->nullauth = 1;
> +               vol->nullauth = true;
>                 break;
>         default:
>                 cifs_dbg(VFS, "bad security option: %s\n", value);
> @@ -1265,9 +1265,9 @@ cifs_parse_mount_options(const char *mou
>
>         /* vol->retry default is 0 (i.e. "soft" limited retry not hard retry) */
>         /* default is always to request posix paths. */
> -       vol->posix_paths = 1;
> +       vol->posix_paths = true;
>         /* default to using server inode numbers where available */
> -       vol->server_ino = 1;
> +       vol->server_ino = true;
>
>         /* default is to use strict cifs caching semantics */
>         vol->strict_io = true;
> @@ -1333,10 +1333,10 @@ cifs_parse_mount_options(const char *mou
>
>                 /* Boolean values */
>                 case Opt_user_xattr:
> -                       vol->no_xattr = 0;
> +                       vol->no_xattr = false;
>                         break;
>                 case Opt_nouser_xattr:
> -                       vol->no_xattr = 1;
> +                       vol->no_xattr = true;
>                         break;
>                 case Opt_forceuid:
>                         override_uid = 1;
> @@ -1351,22 +1351,22 @@ cifs_parse_mount_options(const char *mou
>                         override_gid = 0;
>                         break;
>                 case Opt_noblocksend:
> -                       vol->noblocksnd = 1;
> +                       vol->noblocksnd = true;
>                         break;
>                 case Opt_noautotune:
> -                       vol->noautotune = 1;
> +                       vol->noautotune = true;
>                         break;
>                 case Opt_hard:
> -                       vol->retry = 1;
> +                       vol->retry = true;
>                         break;
>                 case Opt_soft:
> -                       vol->retry = 0;
> +                       vol->retry = false;
>                         break;
>                 case Opt_perm:
> -                       vol->noperm = 0;
> +                       vol->noperm = false;
>                         break;
>                 case Opt_noperm:
> -                       vol->noperm = 1;
> +                       vol->noperm = true;
>                         break;
>                 case Opt_mapchars:
>                         vol->sfu_remap = true;
> @@ -1383,31 +1383,31 @@ cifs_parse_mount_options(const char *mou
>                         vol->remap = false;
>                         break;
>                 case Opt_sfu:
> -                       vol->sfu_emul = 1;
> +                       vol->sfu_emul = true;
>                         break;
>                 case Opt_nosfu:
> -                       vol->sfu_emul = 0;
> +                       vol->sfu_emul = false;
>                         break;
>                 case Opt_nodfs:
> -                       vol->nodfs = 1;
> +                       vol->nodfs = true;
>                         break;
>                 case Opt_posixpaths:
> -                       vol->posix_paths = 1;
> +                       vol->posix_paths = true;
>                         break;
>                 case Opt_noposixpaths:
> -                       vol->posix_paths = 0;
> +                       vol->posix_paths = false;
>                         break;
>                 case Opt_nounix:
> -                       vol->no_linux_ext = 1;
> +                       vol->no_linux_ext = true;
>                         break;
>                 case Opt_nocase:
> -                       vol->nocase = 1;
> +                       vol->nocase = true;
>                         break;
>                 case Opt_brl:
> -                       vol->nobrl =  0;
> +                       vol->nobrl =  false;
>                         break;
>                 case Opt_nobrl:
> -                       vol->nobrl =  1;
> +                       vol->nobrl =  true;
>                         /*
>                          * turn off mandatory locking in mode
>                          * if remote locking is turned off since the
> @@ -1418,16 +1418,16 @@ cifs_parse_mount_options(const char *mou
>                                 vol->file_mode = S_IALLUGO;
>                         break;
>                 case Opt_forcemandatorylock:
> -                       vol->mand_lock = 1;
> +                       vol->mand_lock = true;
>                         break;
>                 case Opt_setuids:
> -                       vol->setuids = 1;
> +                       vol->setuids = true;
>                         break;
>                 case Opt_nosetuids:
> -                       vol->setuids = 0;
> +                       vol->setuids = false;
>                         break;
>                 case Opt_setuidfromacl:
> -                       vol->setuidfromacl = 1;
> +                       vol->setuidfromacl = true;
>                         break;
>                 case Opt_dynperm:
>                         vol->dynperm = true;
> @@ -1436,46 +1436,46 @@ cifs_parse_mount_options(const char *mou
>                         vol->dynperm = false;
>                         break;
>                 case Opt_nohard:
> -                       vol->retry = 0;
> +                       vol->retry = false;
>                         break;
>                 case Opt_nosoft:
> -                       vol->retry = 1;
> +                       vol->retry = true;
>                         break;
>                 case Opt_nointr:
> -                       vol->intr = 0;
> +                       vol->intr = false;
>                         break;
>                 case Opt_intr:
> -                       vol->intr = 1;
> +                       vol->intr = true;
>                         break;
>                 case Opt_nostrictsync:
> -                       vol->nostrictsync = 1;
> +                       vol->nostrictsync = true;
>                         break;
>                 case Opt_strictsync:
> -                       vol->nostrictsync = 0;
> +                       vol->nostrictsync = false;
>                         break;
>                 case Opt_serverino:
> -                       vol->server_ino = 1;
> +                       vol->server_ino = true;
>                         break;
>                 case Opt_noserverino:
> -                       vol->server_ino = 0;
> +                       vol->server_ino = false;
>                         break;
>                 case Opt_rwpidforward:
> -                       vol->rwpidforward = 1;
> +                       vol->rwpidforward = true;
>                         break;
>                 case Opt_cifsacl:
> -                       vol->cifs_acl = 1;
> +                       vol->cifs_acl = true;
>                         break;
>                 case Opt_nocifsacl:
> -                       vol->cifs_acl = 0;
> +                       vol->cifs_acl = false;
>                         break;
>                 case Opt_acl:
> -                       vol->no_psx_acl = 0;
> +                       vol->no_psx_acl = false;
>                         break;
>                 case Opt_noacl:
> -                       vol->no_psx_acl = 1;
> +                       vol->no_psx_acl = true;
>                         break;
>                 case Opt_locallease:
> -                       vol->local_lease = 1;
> +                       vol->local_lease = true;
>                         break;
>                 case Opt_sign:
>                         vol->sign = true;
> @@ -1486,7 +1486,7 @@ cifs_parse_mount_options(const char *mou
>                          * or per-smb connection option in the protocol
>                          * vol->secFlg |= CIFSSEC_MUST_SEAL;
>                          */
> -                       vol->seal = 1;
> +                       vol->seal = true;
>                         break;
>                 case Opt_noac:
>                         pr_warn("CIFS: Mount option noac not supported. Instead set /proc/fs/cifs/LookupCacheEnabled to 0\n");
> @@ -1664,7 +1664,7 @@ cifs_parse_mount_options(const char *mou
>
>                 case Opt_blank_user:
>                         /* null user, ie. anonymous authentication */
> -                       vol->nullauth = 1;
> +                       vol->nullauth = true;
>                         vol->username = NULL;
>                         break;
>                 case Opt_user:
> @@ -1986,7 +1986,7 @@ cifs_parse_mount_options(const char *mou
>         else if (override_gid == 1)
>                 pr_notice("CIFS: ignoring forcegid mount option specified with no gid= option.\n");
>
> -       if (got_version == false)
> +       if (!got_version)
>                 pr_warn("No dialect specified on mount. Default has changed to "
>                         "a more secure dialect, SMB3 (vers=3.0), from CIFS "
>                         "(SMB1). To use the less secure SMB1 dialect to access "
> @@ -2800,7 +2800,7 @@ cifs_get_tcon(struct cifs_ses *ses, stru
>                 }
>         } else if ((tcon->capabilities & SMB2_SHARE_CAP_CONTINUOUS_AVAILABILITY)
>              && (ses->server->capabilities & SMB2_GLOBAL_CAP_PERSISTENT_HANDLES)
> -            && (volume_info->nopersistent == false)) {
> +            && (!volume_info->nopersistent)) {
>                 cifs_dbg(FYI, "enabling persistent handles\n");
>                 tcon->use_persistent = true;
>         } else if (volume_info->resilient) {
> @@ -3289,13 +3289,13 @@ void reset_cifs_unix_caps(unsigned int x
>
>         if (vol_info && vol_info->no_linux_ext) {
>                 tcon->fsUnixInfo.Capability = 0;
> -               tcon->unix_ext = 0; /* Unix Extensions disabled */
> +               tcon->unix_ext = false; /* Unix Extensions disabled */
>                 cifs_dbg(FYI, "Linux protocol extensions disabled\n");
>                 return;
>         } else if (vol_info)
> -               tcon->unix_ext = 1; /* Unix Extensions supported */
> +               tcon->unix_ext = true; /* Unix Extensions supported */
>
> -       if (tcon->unix_ext == 0) {
> +       if (!tcon->unix_ext) {
>                 cifs_dbg(FYI, "Unix extensions disabled so not set on reconnect\n");
>                 return;
>         }
> @@ -3333,7 +3333,7 @@ void reset_cifs_unix_caps(unsigned int x
>                                         CIFS_MOUNT_POSIXACL;
>                 }
>
> -               if (vol_info && vol_info->posix_paths == 0)
> +               if (vol_info && !vol_info->posix_paths)
>                         cap &= ~CIFS_UNIX_POSIX_PATHNAMES_CAP;
>                 else if (cap & CIFS_UNIX_POSIX_PATHNAMES_CAP) {
>                         cifs_dbg(FYI, "negotiate posix pathnames\n");
> @@ -3740,8 +3740,8 @@ try_mount_again:
>                 goto mount_fail_check;
>         }
>
> -       if ((volume_info->persistent == true) && ((ses->server->capabilities &
> -               SMB2_GLOBAL_CAP_PERSISTENT_HANDLES) == 0)) {
> +       if ((volume_info->persistent) && ((ses->server->capabilities &
> +                                          SMB2_GLOBAL_CAP_PERSISTENT_HANDLES) == 0)) {
>                 cifs_dbg(VFS, "persistent handles not supported by server\n");
>                 rc = -EOPNOTSUPP;
>                 goto mount_fail_check;
> @@ -3770,7 +3770,7 @@ try_mount_again:
>                         goto mount_fail_check;
>                 }
>         } else
> -               tcon->unix_ext = 0; /* server does not support them */
> +               tcon->unix_ext = false; /* server does not support them */
>
>         /* do not care if a following call succeed - informational */
>         if (!tcon->ipc && server->ops->qfs_tcon)
> @@ -4032,7 +4032,7 @@ CIFSTCon(const unsigned int xid, struct
>                         if ((bcc_ptr[0] == 'I') && (bcc_ptr[1] == 'P') &&
>                             (bcc_ptr[2] == 'C')) {
>                                 cifs_dbg(FYI, "IPC connection\n");
> -                               tcon->ipc = 1;
> +                               tcon->ipc = true;
>                         }
>                 } else if (length == 2) {
>                         if ((bcc_ptr[0] == 'A') && (bcc_ptr[1] == ':')) {
> @@ -4138,7 +4138,7 @@ cifs_setup_session(const unsigned int xi
>         struct TCP_Server_Info *server = ses->server;
>
>         ses->capabilities = server->capabilities;
> -       if (linuxExtEnabled == 0)
> +       if (!linuxExtEnabled)
>                 ses->capabilities &= (~server->vals->cap_unix);
>
>         cifs_dbg(FYI, "Security Mode: 0x%x Capabilities: 0x%x TimeAdjust: %d\n",
> diff -u -p a/fs/cifs/file.c b/fs/cifs/file.c
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -702,7 +702,7 @@ cifs_reopen_file(struct cifsFileInfo *cf
>          * not dirty locally we could do this.
>          */
>         rc = server->ops->open(xid, &oparms, &oplock, NULL);
> -       if (rc == -ENOENT && oparms.reconnect == false) {
> +       if (rc == -ENOENT && !oparms.reconnect) {
>                 /* durable handle timeout is expired - open the file again */
>                 rc = server->ops->open(xid, &oparms, &oplock, NULL);
>                 /* indicate that we need to relock the file */
> diff -u -p a/fs/cifs/inode.c b/fs/cifs/inode.c
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -804,7 +804,7 @@ cifs_get_inode_info(struct inode **inode
>          */
>         if (*inode == NULL) {
>                 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) {
> -                       if (validinum == false) {
> +                       if (!validinum) {
>                                 if (server->ops->get_srv_inum)
>                                         tmprc = server->ops->get_srv_inum(xid,
>                                                 tcon, cifs_sb, full_path,
> @@ -820,7 +820,7 @@ cifs_get_inode_info(struct inode **inode
>                         fattr.cf_uniqueid = iunique(sb, ROOT_I);
>         } else {
>                 if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) &&
> -                   validinum == false && server->ops->get_srv_inum) {
> +                   !validinum && server->ops->get_srv_inum) {
>                         /*
>                          * Pass a NULL tcon to ensure we don't make a round
>                          * trip to the server. This only works for SMB2+.
> diff -u -p a/fs/cifs/misc.c b/fs/cifs/misc.c
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -506,7 +506,7 @@ is_valid_oplock_break(char *buffer, stru
>  void
>  dump_smb(void *buf, int smb_buf_length)
>  {
> -       if (traceSMB == 0)
> +       if (!traceSMB)
>                 return;
>
>         print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_NONE, 8, 2, buf,
> diff -u -p a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
> --- a/fs/cifs/smb2misc.c
> +++ b/fs/cifs/smb2misc.c
> @@ -376,7 +376,7 @@ smb2_calc_size(void *buf)
>          */
>         len += le16_to_cpu(pdu->StructureSize2);
>
> -       if (has_smb2_data_area[le16_to_cpu(shdr->Command)] == false)
> +       if (!has_smb2_data_area[le16_to_cpu(shdr->Command)])
>                 goto calc_size_exit;
>
>         smb2_get_data_area_len(&offset, &data_length, hdr);
> diff -u -p a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -1664,7 +1664,7 @@ static long smb3_zero_range(struct file
>
>         /* if file not oplocked can't be sure whether asking to extend size */
>         if (!CIFS_CACHE_READ(cifsi))
> -               if (keep_size == false)
> +               if (!keep_size)
>                         return -EOPNOTSUPP;
>
>         /*
> @@ -1680,7 +1680,7 @@ static long smb3_zero_range(struct file
>          * this to zero the first part of the range then set the file size
>          * which for a non sparse file would zero the newly extended range
>          */
> -       if (keep_size == false)
> +       if (!keep_size)
>                 if (i_size_read(inode) < offset + len)
>                         return -EOPNOTSUPP;
>
> @@ -1749,7 +1749,7 @@ static long smb3_simple_falloc(struct fi
>
>         /* if file not oplocked can't be sure whether asking to extend size */
>         if (!CIFS_CACHE_READ(cifsi))
> -               if (keep_size == false)
> +               if (!keep_size)
>                         return -EOPNOTSUPP;
>
>         /*
> @@ -1758,7 +1758,7 @@ static long smb3_simple_falloc(struct fi
>          * then no need to do anything since file already allocated
>          */
>         if ((cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE) == 0) {
> -               if (keep_size == true)
> +               if (keep_size)
>                         return 0;
>                 /* check if extending file */
>                 else if (i_size_read(inode) >= off + len)
> @@ -1769,7 +1769,7 @@ static long smb3_simple_falloc(struct fi
>                         return -EOPNOTSUPP;
>         }
>
> -       if ((keep_size == true) || (i_size_read(inode) >= off + len)) {
> +       if ((keep_size) || (i_size_read(inode) >= off + len)) {
>                 /*
>                  * Check if falloc starts within first few pages of file
>                  * and ends within a few pages of the end of file to
> diff -u -p a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -617,7 +617,7 @@ int smb3_validate_negotiate(const unsign
>          * would also enable signing on the mount. Having validation of
>          * negotiate info for signed connections helps reduce attack vectors
>          */
> -       if (tcon->ses->server->sign == false)
> +       if (!tcon->ses->server->sign)
>                 return 0; /* validation requires signing */
>
>         vneg_inbuf.Capabilities =
>
