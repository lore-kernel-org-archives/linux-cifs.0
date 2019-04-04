Return-Path: <SRS0=TNZY=SG=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0238C4360F
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Apr 2019 17:17:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FE7E206BA
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Apr 2019 17:17:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=paulo.ac header.i=@paulo.ac header.b="ASKKhKyn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728650AbfDDRRV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 4 Apr 2019 13:17:21 -0400
Received: from mail.paulo.ac ([51.15.136.203]:50288 "EHLO mail.paulo.ac"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727152AbfDDRRV (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 4 Apr 2019 13:17:21 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.paulo.ac (Postfix) with ESMTP id 0D7A11C17C7
        for <linux-cifs@vger.kernel.org>; Thu,  4 Apr 2019 17:17:17 +0000 (UTC)
X-Amavis-Alert: BAD HEADER SECTION, Duplicate header field: "Cc"
From:   Paulo Alcantara <paulo@paulo.ac>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=paulo.ac; s=201902;
        t=1554398236; bh=W9TUw15msX7A7/kf3TeNT+eYBjQsMs6NG8bNg/mYV3E=;
        h=From:To:Cc:Cc:Subject:In-Reply-To:References:Date:From;
        b=ASKKhKynK5r980diLGE9wPwbPF6ZmzNEUT/UuhsUPzLRCubky1lU2+0pRjOagA6yf
         bNNL6QFIofvx48fC++ufQv2kqhB0eP0mftxB385FQqX7T4+ASCjft8+OAb45hQ0gJs
         ACI+LrGTspisCfSNHqiIGhJqx8GtxrmYzkTWXczZjq2k5ilZYPZE83o2jvPaPY+P7M
         /vgNO90yYNffbganGLpJkhwK0hx4bNDEC7XDUoYxg363paB5BMGDpkrsN7XqXogY+6
         4HNBn7uSzlinYtotWTZWjQN8hf8mCfFGtkfJmwVCEnVdoiuTay8knj7eRJdQEH5gfo
         AXpo4/h53Gm4Q==
To:     Pavel Shilovsky <piastryyy@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>,
        Steve French <smfrench@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Subject: Re: current patches for cifs-utils release
In-Reply-To: <CAKywueQXe4QZyTZBi+HjXhD5LJKrOWOHmKAhfRP0B7rYO2RXew@mail.gmail.com>
References: <CAKywueQXe4QZyTZBi+HjXhD5LJKrOWOHmKAhfRP0B7rYO2RXew@mail.gmail.com>
Date:   Thu, 04 Apr 2019 14:16:54 -0300
Message-ID: <875zrtg06x.fsf@paulo.ac>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Pavel Shilovsky <piastryyy@gmail.com> writes:

> Hi all,
>
> for-next branch is updated with the patches in attachments (resulting
> of merging some of the patches and fixing up some minor style
> problems):
>
> https://github.com/piastry/cifs-utils/commits/next
>
> Please take a look if anything is missed.

Looks good to me. Thanks!

Reviewed-by: Paulo Alcantara <palcantara@suse.de>

cheers,
Paulo

>
> --
> Best regards,
> Pavel Shilovsky
> From 7cf164b0fbddcc343226df7e096ecd82080f3350 Mon Sep 17 00:00:00 2001
> From: Steve French <stfrench@microsoft.com>
> Date: Fri, 29 Mar 2019 03:05:55 -0500
> Subject: [PATCH 1/7] smbinfo: Add ability to query snapshots (previous
>  versions)
>
>  "smbinfo list-snapshots"
>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
> ---
>  smbinfo.c   | 108 ++++++++++++++++++++++++++++++++++++++++++++++++++++++=
+++++-
>  smbinfo.rst |   2 ++
>  2 files changed, 109 insertions(+), 1 deletion(-)
>
> diff --git a/smbinfo.c b/smbinfo.c
> index 33fca95..adfd85e 100644
> --- a/smbinfo.c
> +++ b/smbinfo.c
> @@ -89,6 +89,8 @@ usage(char *name)
>  		"      Prints the security descriptor for a cifs file.\n"
>  		"  quota:\n"
>  		"      Prints the quota for a cifs file.\n"
> +		"  list-snapshots:\n"
> +		"      List the previous versions of the volume that backs this file.\=
n"
>  		"  fsctl-getobjid:\n"
>  		"      Prints the objectid of the file and GUID of the underlying volu=
me.\n",
>  		name);
> @@ -882,7 +884,6 @@ print_quota(unsigned char *sd)
>  	uint32_t u32, neo;
>  	uint64_t u64;
>  	struct timeval tv;
> -	struct tm;
>  	int i, off =3D 0;
>=20=20
>  one_more:
> @@ -966,6 +967,109 @@ quota(int f)
>  	free(qi);
>  }
>=20=20
> +
> +struct smb_snapshot_array {
> +	int32_t	number_of_snapshots;
> +	int32_t	number_of_snapshots_returned;
> +	int32_t	snapshot_array_size;
> +	char snapshot_data[0];
> +};
> +
> +
> +#define GMT_NAME_LEN 24 /* length of a @GMT- name */
> +#define GMT_FORMAT "@GMT-%Y.%m.%d-%H.%M.%S"
> +
> +#define NTFS_TIME_OFFSET ((unsigned long long)(369*365 + 89) * 24 * 3600=
 * 10000000)
> +
> +static void print_snapshots(struct smb_snapshot_array *psnap)
> +{
> +	int current_snapshot_entry =3D 0;
> +	char gmt_token[GMT_NAME_LEN + 1] =3D {0};
> +	int i;
> +	int j =3D 0;
> +	struct tm tm;
> +	unsigned long long dce_time;
> +
> +	printf("Number of snapshots: %d Number of snapshots returned: %d\n",
> +		psnap->number_of_snapshots,
> +		psnap->number_of_snapshots_returned);
> +	printf("Snapshot list in GMT (Coordinated UTC Time) and SMB format (100=
 nanosecond units needed for snapshot mounts):");
> +	for (i =3D 0; i < psnap->snapshot_array_size; i++) {
> +		if (psnap->snapshot_data[i] =3D=3D '@') {
> +			j =3D 0;
> +			current_snapshot_entry++;
> +			printf("\n%d) GMT:", current_snapshot_entry);
> +		}
> +		if (psnap->snapshot_data[i] !=3D 0) {
> +			gmt_token[j] =3D psnap->snapshot_data[i];
> +			j++;
> +		}
> +		if (j =3D=3D GMT_NAME_LEN) {
> +			printf("%s", gmt_token);
> +			j =3D 0;
> +			strptime(gmt_token, GMT_FORMAT, &tm);
> +			dce_time =3D timegm(&tm) * 10000000 + NTFS_TIME_OFFSET;
> +			printf("\n   SMB3:%llu", dce_time);
> +		}
> +	}
> +	printf("\n");
> +}
> +
> +#define CIFS_ENUMERATE_SNAPSHOTS _IOR(CIFS_IOCTL_MAGIC, 6, struct smb_sn=
apshot_array)
> +
> +#define MIN_SNAPSHOT_ARRAY_SIZE 16 /* See MS-SMB2 section 3.3.5.15.1 */
> +
> +static void
> +list_snapshots(int f)
> +{
> +
> +	struct smb_snapshot_array snap_inf;
> +	struct smb_snapshot_array *buf;
> +
> +	/*
> +	 * When first field in structure we pass in here is zero, cifs.ko can
> +	 * recognize that this is the first query and that it must set the SMB3
> +	 * FSCTL response buffer size (in the request) to exactly 16 bytes
> +	 * (which is required by some servers to process the initial query)
> +	 */
> +	snap_inf.number_of_snapshots =3D 0;
> +	snap_inf.number_of_snapshots_returned =3D 0;
> +	snap_inf.snapshot_array_size =3D sizeof(struct smb_snapshot_array);
> +
> +	/* Query the number of snapshots so we know how much to allocate */
> +	if (ioctl(f, CIFS_ENUMERATE_SNAPSHOTS, &snap_inf) < 0) {
> +		fprintf(stderr, "Querying snapshots failed with %s\n", strerror(errno)=
);
> +		exit(1);
> +	}
> +
> +	if (snap_inf.number_of_snapshots =3D=3D 0)
> +		return;
> +
> +	/* Now that we know the size, query the list from the server */
> +
> +	buf =3D malloc(snap_inf.snapshot_array_size + MIN_SNAPSHOT_ARRAY_SIZE);
> +
> +	if (buf =3D=3D NULL) {
> +		printf("Failed, out of memory.\n");
> +		exit(1);
> +	}
> +	/*
> +	 * first parm is non-zero which allows cifs.ko to recognize that this is
> +	 * the second query (it has to set response buf size larger)
> +	 */
> +	buf->number_of_snapshots =3D snap_inf.number_of_snapshots;
> +
> +	buf->snapshot_array_size =3D snap_inf.snapshot_array_size;
> +
> +	if (ioctl(f, CIFS_ENUMERATE_SNAPSHOTS, buf) < 0) {
> +		fprintf(stderr, "Querying snapshots failed with %s\n", strerror(errno)=
);
> +		exit(1);
> +	}
> +
> +	print_snapshots(buf);
> +	free(buf);
> +}
> +
>  int main(int argc, char *argv[])
>  {
>  	int c;
> @@ -1016,6 +1120,8 @@ int main(int argc, char *argv[])
>  		secdesc(f);
>  	else if (!strcmp(argv[optind], "quota"))
>  		quota(f);
> +	else if (!strcmp(argv[optind], "list-snapshots"))
> +		list_snapshots(f);
>  	else if (!strcmp(argv[1], "fsctl-getobjid"))
>  		fsctlgetobjid(f);
>  	else {
> diff --git a/smbinfo.rst b/smbinfo.rst
> index fd7f0ff..0c96050 100644
> --- a/smbinfo.rst
> +++ b/smbinfo.rst
> @@ -64,6 +64,8 @@ COMMAND
>=20=20
>  `fsctl-getobjid`: Prints the ObjectID
>=20=20
> +`list-snapshots`: Lists the previous versions of the volume that backs t=
his file
> +
>  `quota`: Print the quota for the volume in the form
>  - SID Length
>  - Change Time
> --=20
> 2.7.4
>
> From e8b8bb5fa61c53b05975650194da24786c4a4f32 Mon Sep 17 00:00:00 2001
> From: Pavel Shilovsky <pshilov@microsoft.com>
> Date: Wed, 3 Apr 2019 22:42:10 +0000
> Subject: [PATCH 5/7] mount.cifs: detect GMT format of snapshot version
>
> In order to provide an easy way to access snapshots a GMT
> token string should be allowed as a "snapshot" mount option
> argument, not SMB 100-nanoseconds time only. Detect if the
> argument is in GMT format and convert it to SMB 100-nanoseconds
> time before passing to the kernel.
>
> Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
> ---
>  mount.cifs.c | 54 +++++++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 47 insertions(+), 7 deletions(-)
>
> diff --git a/mount.cifs.c b/mount.cifs.c
> index c6a1bd6..b3235e4 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -43,6 +43,7 @@
>  #include <limits.h>
>  #include <paths.h>
>  #include <libgen.h>
> +#include <time.h>
>  #include <sys/mman.h>
>  #include <sys/wait.h>
>  #ifdef HAVE_SYS_FSUID_H
> @@ -161,10 +162,16 @@
>  #define OPT_BKUPUID    30
>  #define OPT_BKUPGID    31
>  #define OPT_NOFAIL     32
> +#define OPT_SNAPSHOT   33
>=20=20
>  #define MNT_TMP_FILE "/.mtab.cifs.XXXXXX"
>=20=20
> -/* struct for holding parsed mount info for use by privleged process */
> +#define GMT_NAME_LEN 24 /* length of a @GMT- name */
> +#define GMT_FORMAT "@GMT-%Y.%m.%d-%H.%M.%S"
> +
> +#define NTFS_TIME_OFFSET ((unsigned long long)(369*365 + 89) * 24 * 3600=
 * 10000000)
> +
> +/* struct for holding parsed mount info for use by privileged process */
>  struct parsed_mount_info {
>  	unsigned long flags;
>  	char host[NI_MAXHOST + 1];
> @@ -271,9 +278,9 @@ static int mount_usage(FILE * stream)
>  	fprintf(stream,
>  		"\n\tcache=3D<strict|none|loose>,nounix,cifsacl,sec=3D<authentication =
mechanism>,");
>  	fprintf(stream,
> -		"\n\tsign,seal,fsc,snapshot=3D<time>,nosharesock,persistenthandles,res=
ilienthandles,");
> +		"\n\tsign,seal,fsc,snapshot=3D<token|time>,nosharesock,persistenthandl=
es,");
>  	fprintf(stream,
> -		"\n\trdma,vers=3D<smb_dialect>,cruid");
> +		"\n\tresilienthandles,rdma,vers=3D<smb_dialect>,cruid");
>  	fprintf(stream,
>  		"\n\nOptions not needed for servers supporting CIFS Unix extensions");
>  	fprintf(stream,
> @@ -773,6 +780,8 @@ static int parse_opt_token(const char *token)
>  		return OPT_NOFAIL;
>  	if (strncmp(token, "x-", 2) =3D=3D 0)
>  		return OPT_IGNORE;
> +	if (strncmp(token, "snapshot", 8) =3D=3D 0)
> +		return OPT_SNAPSHOT;
>=20=20
>  	return OPT_ERROR;
>  }
> @@ -793,16 +802,19 @@ parse_options(const char *data, struct parsed_mount=
_info *parsed_info)
>  	int got_uid =3D 0;
>  	int got_cruid =3D 0;
>  	int got_gid =3D 0;
> +	int got_snapshot =3D 0;
>  	uid_t uid, cruid =3D 0, bkupuid =3D 0;
>  	gid_t gid, bkupgid =3D 0;
>  	char *ep;
>  	struct passwd *pw;
>  	struct group *gr;
>  	/*
> -	 * max 32-bit uint in decimal is 4294967295 which is 10 chars wide
> -	 * +1 for NULL, and +1 for good measure
> +	 * max 64-bit uint in decimal is 18446744073709551615 which is 20 chars
> +	 * wide +1 for NULL, and +1 for good measure
>  	 */
> -	char txtbuf[12];
> +	char txtbuf[22];
> +	unsigned long long snapshot;
> +	struct tm tm;
>=20=20
>  	/* make sure we're starting from beginning */
>  	out[0] =3D '\0';
> @@ -1130,6 +1142,19 @@ parse_options(const char *data, struct parsed_moun=
t_info *parsed_info)
>  		case OPT_NOFAIL:
>  			parsed_info->nofail =3D 1;
>  			goto nocopy;
> +		case OPT_SNAPSHOT:
> +			if (!value || !*value)
> +				goto nocopy;
> +			if (strncmp(value, "@GMT-", 5))
> +				break;
> +			if ((strlen(value) !=3D GMT_NAME_LEN) ||
> +			    (strptime(value, GMT_FORMAT, &tm) =3D=3D NULL)) {
> +				fprintf(stderr, "bad snapshot token\n");
> +				return EX_USAGE;
> +			}
> +			snapshot =3D timegm(&tm) * 10000000 + NTFS_TIME_OFFSET;
> +			got_snapshot =3D 1;
> +			goto nocopy;
>  		}
>=20=20
>  		/* check size before copying option to buffer */
> @@ -1225,7 +1250,7 @@ nocopy:
>  	if (got_bkupgid) {
>  		word_len =3D snprintf(txtbuf, sizeof(txtbuf), "%u", bkupgid);
>=20=20
> -		/* comma + "backkupgid=3D" + terminating NULL =3D=3D 12 */
> +		/* comma + "backupgid=3D" + terminating NULL =3D=3D 12 */
>  		if (out_len + word_len + 12 > MAX_OPTIONS_LEN) {
>  			fprintf(stderr, "Options string too long\n");
>  			return EX_USAGE;
> @@ -1237,6 +1262,21 @@ nocopy:
>  		}
>  		snprintf(out + out_len, word_len + 11, "backupgid=3D%s", txtbuf);
>  	}
> +	if (got_snapshot) {
> +		word_len =3D snprintf(txtbuf, sizeof(txtbuf), "%llu", snapshot);
> +
> +		/* comma + "snapshot=3D" + terminating NULL =3D=3D 11 */
> +		if (out_len + word_len + 11 > MAX_OPTIONS_LEN) {
> +			fprintf(stderr, "Options string too long\n");
> +			return EX_USAGE;
> +		}
> +
> +		if (out_len) {
> +			strlcat(out, ",", MAX_OPTIONS_LEN);
> +			out_len++;
> +		}
> +		snprintf(out + out_len, word_len + 11, "snapshot=3D%s", txtbuf);
> +	}
>=20=20
>  	return 0;
>  }
> --=20
> 2.7.4
>
> From 6ef851043c4a36be0b0657d4d3cf3a1ab9be6efb Mon Sep 17 00:00:00 2001
> From: Pavel Shilovsky <pshilov@microsoft.com>
> Date: Wed, 3 Apr 2019 12:24:33 -0700
> Subject: [PATCH 4/7] mount.cifs: add more options to help message
>
> Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
> ---
>  mount.cifs.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/mount.cifs.c b/mount.cifs.c
> index d921fed..c6a1bd6 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -267,13 +267,13 @@ static int mount_usage(FILE * stream)
>  	fprintf(stream,
>  		"\n\tsep=3D<char>,iocharset=3D<codepage>,suid,nosuid,exec,noexec,serve=
rino,");
>  	fprintf(stream,
> -		"\n\tmapchars,nomapchars,nolock,servernetbiosname=3D<SRV_RFC1001NAME>"=
);
> +		"\n\tnoserverino,mapchars,nomapchars,nolock,servernetbiosname=3D<SRV_R=
FC1001NAME>");
>  	fprintf(stream,
> -		"\n\tdirectio,nounix,cifsacl,sec=3D<authentication mechanism>,sign,sea=
l,fsc,");
> +		"\n\tcache=3D<strict|none|loose>,nounix,cifsacl,sec=3D<authentication =
mechanism>,");
>  	fprintf(stream,
> -		"\n\tsnapshot=3D<time>,nosharesock,persistenthandles,resilienthandles,=
rdma,");
> +		"\n\tsign,seal,fsc,snapshot=3D<time>,nosharesock,persistenthandles,res=
ilienthandles,");
>  	fprintf(stream,
> -		"\n\tvers=3D<smb_dialect>,cruid");
> +		"\n\trdma,vers=3D<smb_dialect>,cruid");
>  	fprintf(stream,
>  		"\n\nOptions not needed for servers supporting CIFS Unix extensions");
>  	fprintf(stream,
> @@ -290,7 +290,9 @@ static int mount_usage(FILE * stream)
>  	fprintf(stream,
>  		"\n\tnointr,ignorecase,noposixpaths,noacl,prefixpath=3D<path>,nobrl,");
>  	fprintf(stream,
> -		"\n\techo_interval=3D<seconds>,actimeo=3D<seconds>,max_credits=3D<cred=
its>");
> +		"\n\techo_interval=3D<seconds>,actimeo=3D<seconds>,max_credits=3D<cred=
its>,");
> +	fprintf(stream,
> +		"\n\tbsize=3D<size>");
>  	fprintf(stream,
>  		"\n\nOptions are described in more detail in the manual page");
>  	fprintf(stream, "\n\tman 8 mount.cifs\n");
> --=20
> 2.7.4
>
> From 213a508997303dfead74154edf9d137e911e84a0 Mon Sep 17 00:00:00 2001
> From: Pavel Shilovsky <pshilov@microsoft.com>
> Date: Tue, 2 Apr 2019 11:40:40 -0700
> Subject: [PATCH 2/7] smbinfo: make argument order consistent
>
> Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
> ---
>  smbinfo.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
>
> diff --git a/smbinfo.c b/smbinfo.c
> index adfd85e..f9de7fd 100644
> --- a/smbinfo.c
> +++ b/smbinfo.c
> @@ -85,14 +85,14 @@ usage(char *name)
>  		"      Prints FilePositionInfo for a cifs file.\n"
>  		"  filestandardinfo:\n"
>  		"      Prints FileStandardInfo for a cifs file.\n"
> -		"  secdesc:\n"
> -		"      Prints the security descriptor for a cifs file.\n"
> -		"  quota:\n"
> -		"      Prints the quota for a cifs file.\n"
> +		"  fsctl-getobjid:\n"
> +		"      Prints the objectid of the file and GUID of the underlying volu=
me.\n"
>  		"  list-snapshots:\n"
>  		"      List the previous versions of the volume that backs this file.\=
n"
> -		"  fsctl-getobjid:\n"
> -		"      Prints the objectid of the file and GUID of the underlying volu=
me.\n",
> +		"  quota:\n"
> +		"      Prints the quota for a cifs file.\n"
> +		"  secdesc:\n"
> +		"      Prints the security descriptor for a cifs file.\n",
>  		name);
>  	exit(1);
>  }
> @@ -1116,14 +1116,14 @@ int main(int argc, char *argv[])
>  		filepositioninfo(f);
>  	else if (!strcmp(argv[optind], "filestandardinfo"))
>  		filestandardinfo(f);
> -	else if (!strcmp(argv[optind], "secdesc"))
> -		secdesc(f);
> -	else if (!strcmp(argv[optind], "quota"))
> -		quota(f);
> +	else if (!strcmp(argv[optind], "fsctl-getobjid"))
> +		fsctlgetobjid(f);
>  	else if (!strcmp(argv[optind], "list-snapshots"))
>  		list_snapshots(f);
> -	else if (!strcmp(argv[1], "fsctl-getobjid"))
> -		fsctlgetobjid(f);
> +	else if (!strcmp(argv[optind], "quota"))
> +		quota(f);
> +	else if (!strcmp(argv[optind], "secdesc"))
> +		secdesc(f);
>  	else {
>  		fprintf(stderr, "Unknown command %s\n", argv[optind]);
>  		exit(1);
> --=20
> 2.7.4
>
> From 6396a77eac26b3bf15f0fdfb187282aa7d0a5bcf Mon Sep 17 00:00:00 2001
> From: Steve French <stfrench@microsoft.com>
> Date: Tue, 2 Apr 2019 21:18:27 -0500
> Subject: [PATCH 3/7] mount.cifs Add various missing parms from the help t=
ext
>
> When you type mount.cifs --help there were more than 40 mount parms
> missing. Add 12 of the more common ones to what is displayed by help.
>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---
>  mount.cifs.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/mount.cifs.c b/mount.cifs.c
> index 9370f2e..d921fed 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -269,20 +269,28 @@ static int mount_usage(FILE * stream)
>  	fprintf(stream,
>  		"\n\tmapchars,nomapchars,nolock,servernetbiosname=3D<SRV_RFC1001NAME>"=
);
>  	fprintf(stream,
> -		"\n\tdirectio,nounix,cifsacl,sec=3D<authentication mechanism>,sign,sea=
l,fsc");
> +		"\n\tdirectio,nounix,cifsacl,sec=3D<authentication mechanism>,sign,sea=
l,fsc,");
> +	fprintf(stream,
> +		"\n\tsnapshot=3D<time>,nosharesock,persistenthandles,resilienthandles,=
rdma,");
> +	fprintf(stream,
> +		"\n\tvers=3D<smb_dialect>,cruid");
>  	fprintf(stream,
>  		"\n\nOptions not needed for servers supporting CIFS Unix extensions");
>  	fprintf(stream,
>  		"\n\t(e.g. unneeded for mounts to most Samba versions):");
>  	fprintf(stream,
> -		"\n\tuid=3D<uid>,gid=3D<gid>,dir_mode=3D<mode>,file_mode=3D<mode>,sfu"=
);
> +		"\n\tuid=3D<uid>,gid=3D<gid>,dir_mode=3D<mode>,file_mode=3D<mode>,sfu,=
");
> +	fprintf(stream,
> +		"\n\tmfsymlinks,idsfromsid");
>  	fprintf(stream, "\n\nRarely used options:");
>  	fprintf(stream,
>  		"\n\tport=3D<tcpport>,rsize=3D<size>,wsize=3D<size>,unc=3D<unc_name>,i=
p=3D<ip_address>,");
>  	fprintf(stream,
>  		"\n\tdev,nodev,nouser_xattr,netbiosname=3D<OUR_RFC1001NAME>,hard,soft,=
intr,");
>  	fprintf(stream,
> -		"\n\tnointr,ignorecase,noposixpaths,noacl,prefixpath=3D<path>,nobrl");
> +		"\n\tnointr,ignorecase,noposixpaths,noacl,prefixpath=3D<path>,nobrl,");
> +	fprintf(stream,
> +		"\n\techo_interval=3D<seconds>,actimeo=3D<seconds>,max_credits=3D<cred=
its>");
>  	fprintf(stream,
>  		"\n\nOptions are described in more detail in the manual page");
>  	fprintf(stream, "\n\tman 8 mount.cifs\n");
> --=20
> 2.7.4
>
> From 19c1bb71de9f58bb5b1fbc78ab468f80df62ee57 Mon Sep 17 00:00:00 2001
> From: Steve French <stfrench@microsoft.com>
> Date: Wed, 3 Apr 2019 23:46:34 -0500
> Subject: [PATCH 6/7] Update man page for mount.cifs to add new options
>
> Add description of "snapshot" and "handletimeout" mount
> options and a security section noting that the use of
> cifs is discouraged, and various minor updates.
>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
> ---
>  mount.cifs.rst | 98 +++++++++++++++++++++++++++++++++++-----------------=
------
>  1 file changed, 60 insertions(+), 38 deletions(-)
>
> diff --git a/mount.cifs.rst b/mount.cifs.rst
> index f64d1f1..8ba6e7b 100644
> --- a/mount.cifs.rst
> +++ b/mount.cifs.rst
> @@ -15,13 +15,13 @@ SYNOPSIS
>=20=20
>  This tool is part of the cifs-utils suite.
>=20=20
> -``mount.cifs`` mounts a Linux CIFS filesystem. It is usually invoked
> -indirectly by the mount(8) command when using the "-t cifs"
> +``mount.cifs`` mounts a CIFS or SMB3 filesystem from Linux. It is
> +usually invoked indirectly by the mount(8) command when using the "-t ci=
fs"
>  option. This command only works in Linux, and the kernel must support
> -the cifs filesystem. The CIFS protocol is the successor to the SMB
> -protocol and is supported by most Windows servers and many other
> -commercial servers and Network Attached Storage appliances as well as
> -by the popular Open Source server Samba.
> +the cifs filesystem. The SMB3 protocol is the successor to the CIFS (SMB)
> +protocol and is supported by most Windows servers, Azure (cloud storage),
> +Macs and many other commercial servers and Network Attached Storage
> +appliances as well as by the popular Open Source server Samba.
>=20=20
>  The mount.cifs utility attaches the UNC name (exported network
>  resource) specified as service (using ``//server/share`` syntax, where
> @@ -266,6 +266,13 @@ handlecache
>  nohandlecache
>    Disable caching of the share root directory handle.
>=20=20
> +handletimeout=3Darg
> +  The time (in milliseconds) for which the server should reserve the han=
dle after
> +  a failover waiting for the client to reconnect.  When mounting with
> +  resilienthandles or persistenthandles mount option, or when their use =
is
> +  requested by the server (continuous availability shares) then this par=
ameter
> +  overrides the server default handle timeout (which for most servers is=
 120 seconds).
> +
>  rwpidforward
>    Forward pid of a process who opened a file to any read or write
>    operation on that file. This prevent applications like wine(1) from
> @@ -387,6 +394,12 @@ persistenthandles
>  nopersistenthandles
>    (default) Disable persistent handles.
>=20=20
> +snapshot=3Dtime
> +   Mount a specific snapshot of the remote share. ``time`` must be a
> +   positive integer identifying the snapshot requested (in 100-nanosecond
> +   units that have elapsed since January 1, 1601, or alternatively it can
> +   be specified in GMT format e.g. @GMT-2019.03.27-20.52.19)
> +
>  nobrl
>    Do not send byte range lock requests to the server. This is necessary
>    for certain applications that break with cifs style mandatory byte
> @@ -401,7 +414,7 @@ locallease
>    Check cached leases locally instead of querying the server.
>=20=20
>  sfu
> -  When the CIFS Unix Extensions are not negotiated, attempt to create
> +  When the CIFS or SMB3 Unix Extensions are not negotiated, attempt to c=
reate
>    device files and fifos in a format compatible with Services for Unix
>    (SFU). In addition retrieve bits 10-12 of the mode via the
>    ``SETFILEBITS`` extended attribute (as SFU does). In the future the
> @@ -450,11 +463,11 @@ noserverino
>=20=20
>    See section `INODE NUMBERS`_ for more information.
>=20=20
> -unix|linux
> +posix|unix|linux
>    (default) Enable Unix Extensions for this mount. Requires CIFS
>    (vers=3D1.0) or SMB3.1.1 (vers=3D3.1.1) and a server supporting them.
>=20=20
> -nounix|nolinux
> +noposix|nounix|nolinux
>    Disable the Unix Extensions for this mount. This can be useful in
>    order to turn off multiple settings at once. This includes POSIX acls,
>    POSIX locks, POSIX paths, symlink support and retrieving
> @@ -479,38 +492,35 @@ nosharesock
>    Do not try to reuse sockets if the system is already connected to
>    the server via an existing mount point. This will make the client
>    always make a new connection to the server no matter what he is
> -  already connected to.
> +  already connected to. This can be useful in simulating multiple
> +  clients connecting to the same server, as each mount point
> +  will use a different TCP socket.
>=20=20
>  noblocksend
>    Send data on the socket using non blocking operations (MSG_DONTWAIT fl=
ag).
>=20=20
>  rsize=3Dbytes
>    Maximum amount of data that the kernel will request in a read request
> -  in bytes. Prior to kernel 3.2.0, the default was 16k, and the maximum
> -  size was limited by the ``CIFSMaxBufSize`` module parameter. As of
> -  kernel 3.2.0, the behavior varies according to whether POSIX
> -  extensions are enabled on the mount and the server supports large
> -  POSIX reads. If they are, then the default is 1M, and the maximum is
> -  16M. If they are not supported by the server, then the default is 60k
> -  and the maximum is around 127k. The reason for the 60k is because it's
> -  the maximum size read that windows servers can fill. Note that this
> -  value is a maximum, and the client may settle on a smaller size to
> -  accommodate what the server supports. In kernels prior to 3.2.0, no
> -  negotiation is performed.
> +  in bytes. Maximum size that servers will accept is typically 8MB for S=
MB3
> +  or later dialects. Default requested during mount is 4MB. Prior to the=
 4.20
> +  kernel the default requested was 1MB. Prior to the SMB2.1 dialect the
> +  maximum was usually 64K.
>=20=20
>  wsize=3Dbytes
>    Maximum amount of data that the kernel will send in a write request in
> -  bytes. Prior to kernel 3.0.0, the default and maximum was 57344 (14 \*
> -  4096 pages). As of 3.0.0, the default depends on whether the client
> -  and server negotiate large writes via POSIX extensions. If they do,
> -  then the default is 1M, and the maximum allowed is 16M. If they do
> -  not, then the default is 65536 and the maximum allowed is 131007. Note
> -  that this value is just a starting point for negotiation in 3.0.0 and
> -  up. The client and server may negotiate this size downward according
> -  to the server's capabilities. In kernels prior to 3.0.0, no
> -  negotiation is performed. It can end up with an existing superblock if
> -  this value isn't specified or it's greater or equal than the existing
> -  one.
> +  bytes. Maximum size that servers will accept is typically 8MB for SMB3
> +  or later dialects. Default requested during mount is 4MB. Prior to the=
 4.20
> +  kernel the default requested was 1MB. Prior to the SMB2.1 dialect the
> +  maximum was usually 64K.
> +
> +bsize=3Dbytes
> +  Override the default blocksize (1MB) reported on SMB3 files (requires
> +  kernel version of 5.1 or later). Prior to kernel version 5.1, the
> +  blocksize was always reported as 16K instead of 1MB (and was not
> +  configurable) which can hurt the performance of tools like cp and scp
> +  (especially for uncached I/O) which decide on the read and write size
> +  to use for file copies based on the inode blocksize. bsize may not be
> +  less than 16K or greater than 16M.
>=20=20
>  max_credits=3Dn
>    Maximum credits the SMB2 client can have. Default is 32000. Must be
> @@ -885,14 +895,26 @@ CONFIGURATION
>  The primary mechanism for making configuration changes and for reading
>  debug information for the cifs vfs is via the Linux /proc
>  filesystem. In the directory */proc/fs/cifs* are various
> -configuration files and pseudo files which can display debug
> -information. There are additional startup options such as maximum
> -buffer size and number of buffers which only may be set when the
> +configuration files and pseudo files which can display debug information
> +and performance statistics. There are additional startup options such as
> +maximum buffer size and number of buffers which only may be set when the
>  kernel cifs vfs (cifs.ko module) is loaded. These can be seen by
>  running the ``modinfo`` utility against the file cifs.ko which will
>  list the options that may be passed to cifs during module installation
>  (device driver load). For more information see the kernel file
> -*fs/cifs/README*.
> +*fs/cifs/README*. When configuring dynamic tracing (trace-cmd)
> +note that the list of SMB3 events which can be enabled can be seen at:
> +*/sys/kernel/debug/tracing/events/cifs/*.
> +
> +********
> +SECURITY
> +********
> +
> +The use of SMB2.1 or later (including the latest dialect SMB3.1.1)
> +is recommended for improved security and SMB1 is no longer requested
> +by default at mount time. Old dialects such as CIFS (SMB1, ie vers=3D1.0)
> +have much weaker security. Use of CIFS (SMB1) can be disabled by
> +modprobe cifs disable_legacy_dialects=3Dy.
>=20=20
>  ****
>  BUGS
> @@ -913,8 +935,8 @@ bugs (minimum: mount.cifs (try ``mount.cifs -V``), ke=
rnel (see
>  VERSION
>  *******
>=20=20
> -This man page is correct for version 1.74 of the cifs vfs filesystem
> -(roughly Linux kernel 3.0).
> +This man page is correct for version 2.18 of the cifs vfs filesystem
> +(roughly Linux kernel 5.0).
>=20=20
>  ********
>  SEE ALSO
> --=20
> 2.7.4
>
> From 7047e57bcb343ad867728fbddc5a4da29d7ae9fc Mon Sep 17 00:00:00 2001
> From: Pavel Shilovsky <pshilov@microsoft.com>
> Date: Thu, 4 Apr 2019 16:25:30 +0000
> Subject: [PATCH 7/7] mount.cifs.rst: mention kernel version for snapshots
>
> Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
> ---
>  mount.cifs.rst | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/mount.cifs.rst b/mount.cifs.rst
> index 8ba6e7b..02016e0 100644
> --- a/mount.cifs.rst
> +++ b/mount.cifs.rst
> @@ -398,7 +398,8 @@ snapshot=3Dtime
>     Mount a specific snapshot of the remote share. ``time`` must be a
>     positive integer identifying the snapshot requested (in 100-nanosecond
>     units that have elapsed since January 1, 1601, or alternatively it can
> -   be specified in GMT format e.g. @GMT-2019.03.27-20.52.19)
> +   be specified in GMT format e.g. @GMT-2019.03.27-20.52.19). Supported
> +   in the Linux kernel starting from v4.19.
>=20=20
>  nobrl
>    Do not send byte range lock requests to the server. This is necessary
> --=20
> 2.7.4

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEERoXdH1qkUp3jTzChVeljQjyMrg0FAlymPAcACgkQVeljQjyM
rg2/cA/9FqNI2X6ULznx8iNUArzLJIFGHflwdVL+4CQ5LQctqvyddsjuj6FeNUNb
6akrlOl5IM6HLtSv9MWhamX9S8V31nbSbF7hj9FyMACzbUDDs9r6qgj+bHKB/91T
9V0ZjQv9un1tJQ03h8iGAry42n5+e8S8xliLgaZCSOFRaZf2NRmT/4BF9RgA8eEq
SJJG5xCzC2pAasqCkOJhFYIaWF5Em+LTkBKJySUC2XsE9jFrWg0GhBO+32IXuaWr
yJYVL/OlT6HRv3jpUxalSquQXUuenPZ6loWqfFrirAF7Qf3asRQeUD6XufMr7GGD
H66FpDj7aaOiiYhKmzXyOamQIpssSiffsuDrjiYK4ueB7Odr/qABhY7VzHPb9iU5
WOFbHvQDxbE/B8vuZCi7UzZgXdn47zV4EzSOlnmXmD+xmh2fucusqzGYDNXfwulg
8zgZ4nw/kHdYawdx0/1dZXJAVBl0/dijg3AH4DG0TNnPXNZZ/QZTDAYapTqG92cz
4DEzqWIzmVv2krNvPioEk2gmuPpFkR5fv7oI7eeJuW+lXtcJY4vLzzNYzKMdeWNR
H48bO0+nRCoGfJV7SBB3CIsLBBl1PIKFM4BqVs32m1W+Y/Uwn0odXNrkgKJLzrFr
zjSc+UKQO1MlNwNyKLDOjOU4P4HH63UShnm1IzxEGdKGLhMIKcg=
=/tb+
-----END PGP SIGNATURE-----
--=-=-=--
