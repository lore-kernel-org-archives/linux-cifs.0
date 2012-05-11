From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Include backup intent search flags during searches
Date: Fri, 11 May 2012 15:44:40 -0500
Message-ID: <CADT32eL7h9+7VwRXfhNjc-SRymgxBEX0TGC-12zhxgEa3Gd5pw@mail.gmail.com>
References: <1336628304-1208-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tugosavi-xthvdsQ13ZrQT0dZR+AlfA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1336628304-1208-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, May 10, 2012 at 12:38 AM,  <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
>
> As observed and suggested by Tushar Gosavi...
>
> ---------
> readdir calls these function to send TRANS2_FIND_FIRST and
> TRANS2_FIND_NEXT command to the server. The current cifs module is
> not specifying CIFS_SEARCH_BACKUP_SEARCH flag while sending these
> command when backupuid/backupgid is specified. This can be resolved
> by specifying CIFS_SEARCH_BACKUP_SEARCH flag.
> ---------
>
>
> Reported-by: Tushar Gosavi <tugosavi-xthvdsQ13ZrQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> =A0fs/cifs/cifsproto.h | =A0 =A06 ++++--
> =A0fs/cifs/cifssmb.c =A0 | =A0 10 ++++------
> =A0fs/cifs/readdir.c =A0 | =A0 15 +++++++++++++--
> =A03 files changed, 21 insertions(+), 10 deletions(-)
>
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 96192c1..97f5d03 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -192,11 +192,13 @@ extern int CIFSTCon(unsigned int xid, struct ci=
fs_ses *ses,
>
> =A0extern int CIFSFindFirst(const int xid, struct cifs_tcon *tcon,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const char *searchName, const struct n=
ls_table *nls_codepage,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u16 *searchHandle, struct cifs_search=
_info *psrch_inf,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u16 *searchHandle, __u16 search_flags=
,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_search_info *psrch_inf,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int map, const char dirsep);
>
> =A0extern int CIFSFindNext(const int xid, struct cifs_tcon *tcon,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u16 searchHandle, struct cifs_search_=
info *psrch_inf);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u16 searchHandle, __u16 search_flags,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_search_info *psrch_inf);
>
> =A0extern int CIFSFindClose(const int, struct cifs_tcon *tcon,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const __u16 search_han=
dle);
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index da2f544..17c310a 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -4344,7 +4344,7 @@ int
> =A0CIFSFindFirst(const int xid, struct cifs_tcon *tcon,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0const char *searchName,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0const struct nls_table *nls_codepage,
> - =A0 =A0 =A0 =A0 =A0 =A0 __u16 *pnetfid,
> + =A0 =A0 =A0 =A0 =A0 =A0 __u16 *pnetfid, __u16 search_flags,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0struct cifs_search_info *psrch_inf, int re=
map, const char dirsep)
> =A0{
> =A0/* level 257 SMB_ */
> @@ -4416,8 +4416,7 @@ findFirstRetry:
> =A0 =A0 =A0 =A0 =A0 =A0cpu_to_le16(ATTR_READONLY | ATTR_HIDDEN | ATTR=
_SYSTEM |
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ATTR_DIRECTORY);
> =A0 =A0 =A0 =A0pSMB->SearchCount =3D cpu_to_le16(CIFSMaxBufSize/sizeo=
f(FILE_UNIX_INFO));
> - =A0 =A0 =A0 pSMB->SearchFlags =3D cpu_to_le16(CIFS_SEARCH_CLOSE_AT_=
END |
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_SEARCH_RETURN_RESUME);
> + =A0 =A0 =A0 pSMB->SearchFlags =3D cpu_to_le16(search_flags);
> =A0 =A0 =A0 =A0pSMB->InformationLevel =3D cpu_to_le16(psrch_inf->info=
_level);
>
> =A0 =A0 =A0 =A0/* BB what should we set StorageType to? Does it matte=
r? BB */
> @@ -4487,7 +4486,7 @@ findFirstRetry:
> =A0 =A0 =A0 =A0return rc;
> =A0}
>
> -int CIFSFindNext(const int xid, struct cifs_tcon *tcon,
> +int CIFSFindNext(const int xid, struct cifs_tcon *tcon, __u16 search=
_flags,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u16 searchHandle, struct cifs_searc=
h_info *psrch_inf)
> =A0{

Jeff, Thanks.  Need to fix this, so will have to respin with just this =
correct.
search _flags and searchHandle are reversed.

Also, waiting for some test feedback as well before respinning.

Regards,

Shrish
> =A0 =A0 =A0 =A0TRANSACTION2_FNEXT_REQ *pSMB =3D NULL;
> @@ -4531,8 +4530,7 @@ int CIFSFindNext(const int xid, struct cifs_tco=
n *tcon,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cpu_to_le16(CIFSMaxBufSize / sizeof(FI=
LE_UNIX_INFO));
> =A0 =A0 =A0 =A0pSMB->InformationLevel =3D cpu_to_le16(psrch_inf->info=
_level);
> =A0 =A0 =A0 =A0pSMB->ResumeKey =3D psrch_inf->resume_key;
> - =A0 =A0 =A0 pSMB->SearchFlags =3D
> - =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_le16(CIFS_SEARCH_CLOSE_AT_END | CIFS=
_SEARCH_RETURN_RESUME);
> + =A0 =A0 =A0 pSMB->SearchFlags =3D cpu_to_le16(search_flags);
>
> =A0 =A0 =A0 =A0name_len =3D psrch_inf->resume_name_len;
> =A0 =A0 =A0 =A0params +=3D name_len;
> diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> index e2bbc68..297e432 100644
> --- a/fs/cifs/readdir.c
> +++ b/fs/cifs/readdir.c
> @@ -219,6 +219,7 @@ int get_symlink_reparse_path(char *full_path, str=
uct cifs_sb_info *cifs_sb,
>
> =A0static int initiate_cifs_search(const int xid, struct file *file)
> =A0{
> + =A0 =A0 =A0 __u16 search_flags =3D 0;
> =A0 =A0 =A0 =A0int rc =3D 0;
> =A0 =A0 =A0 =A0char *full_path =3D NULL;
> =A0 =A0 =A0 =A0struct cifsFileInfo *cifsFile;
> @@ -270,8 +271,12 @@ ffirst_retry:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifsFile->srch_inf.info_level =3D SMB_=
=46IND_FILE_DIRECTORY_INFO;
> =A0 =A0 =A0 =A0}
>
> + =A0 =A0 =A0 search_flags =3D CIFS_SEARCH_CLOSE_AT_END | CIFS_SEARCH=
_RETURN_RESUME;
> + =A0 =A0 =A0 if (backup_cred(cifs_sb))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 search_flags |=3D CIFS_SEARCH_BACKUP_SE=
ARCH;
> +
> =A0 =A0 =A0 =A0rc =3D CIFSFindFirst(xid, pTcon, full_path, cifs_sb->l=
ocal_nls,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 &cifsFile->netfid, &cifsFile->srch_inf,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 &cifsFile->netfid, search_flags, &cifsF=
ile->srch_inf,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_sb->mnt_cifs_flags &
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CIFS_MOUNT_MAP_SPECIAL=
_CHR, CIFS_DIR_SEP(cifs_sb));
> =A0 =A0 =A0 =A0if (rc =3D=3D 0)
> @@ -502,11 +507,13 @@ static int cifs_save_resume_key(const char *cur=
rent_entry,
> =A0static int find_cifs_entry(const int xid, struct cifs_tcon *pTcon,
> =A0 =A0 =A0 =A0struct file *file, char **ppCurrentEntry, int *num_to_=
ret)
> =A0{
> + =A0 =A0 =A0 __u16 search_flags =3D 0;
> =A0 =A0 =A0 =A0int rc =3D 0;
> =A0 =A0 =A0 =A0int pos_in_buf =3D 0;
> =A0 =A0 =A0 =A0loff_t first_entry_in_buffer;
> =A0 =A0 =A0 =A0loff_t index_to_find =3D file->f_pos;
> =A0 =A0 =A0 =A0struct cifsFileInfo *cifsFile =3D file->private_data;
> + =A0 =A0 =A0 struct cifs_sb_info *cifs_sb =3D CIFS_SB(file->f_path.d=
entry->d_sb);
> =A0 =A0 =A0 =A0/* check if index in the buffer */
>
> =A0 =A0 =A0 =A0if ((cifsFile =3D=3D NULL) || (ppCurrentEntry =3D=3D N=
ULL) ||
> @@ -560,10 +567,14 @@ static int find_cifs_entry(const int xid, struc=
t cifs_tcon *pTcon,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0cifsFile);
> =A0 =A0 =A0 =A0}
>
> + =A0 =A0 =A0 search_flags =3D CIFS_SEARCH_CLOSE_AT_END | CIFS_SEARCH=
_RETURN_RESUME;
> + =A0 =A0 =A0 if (backup_cred(cifs_sb))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 search_flags |=3D CIFS_SEARCH_BACKUP_SE=
ARCH;
> +
> =A0 =A0 =A0 =A0while ((index_to_find >=3D cifsFile->srch_inf.index_of=
_last_entry) &&
> =A0 =A0 =A0 =A0 =A0 =A0 =A0(rc =3D=3D 0) && !cifsFile->srch_inf.endOf=
Search) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "calling findnext2");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSFindNext(xid, pTcon, cifsFil=
e->netfid,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSFindNext(xid, pTcon, cifsFil=
e->netfid, search_flags,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&c=
ifsFile->srch_inf);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* FindFirst/Next set last_entry to NU=
LL on malformed reply */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (cifsFile->srch_inf.last_entry)
> --
> 1.6.0.2
>
