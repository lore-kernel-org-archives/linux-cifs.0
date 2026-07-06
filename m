Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF723B52FF
	for <linux-cifs@vger.kernel.org>; Mon,  6 Jul 2026 16:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783354142; cv=pass; b=Eb4dhJilBHaKfULXCZ20Z5u2ixInoUKxW8XEBylas9pa3BYZllQ8CfMbeqZk/syRdnw40sVfdl54CFYiOfu8mZIZs1c6fQTDaJE+OzUMAGrdxjYwkbhjMRxxFA5P4dArDnfotBxZqkbmozK9LDcR6zH+wH200Lw/BmHni7MhmJI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783354142; c=relaxed/simple;
	bh=+Bo36dG4GjaN4u7fRyfosYRXiP6W2HhVYSCG9StsPwY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y1QOmkWnZhwbTBFvFYSaHDswKJMDLcjeMPW8xNw55WF1+xEBa6iuACSyCrFCwtPHYQR6PIt3NJkWpMmTkTreKmPnMPF1VxefOczprHw+v/B9lc2KPQttbqrN308TyCg3CViilwqs+RkOQa9Q0xNs5JeDnHm9zaTXVWwfj9mUHgY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BgGhwC3c; arc=pass smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BgGhwC3c"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8efef6533aaso24796666d6.0
        for <linux-cifs@vger.kernel.org>; Mon, 06 Jul 2026 09:09:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783354140; cv=none;
        d=google.com; s=arc-20260327;
        b=HiRh96hp3+ZjwIXVoL42Ococ8m2E+eJs+ymospxMEnt/mMJtaq6bQ1SCwnx5rMQlYx
         jeNy/7PYnvXaLwJpALi+dNHBKhG2VMPOI4uLnr1vNMoPVSkalf0kq2F5HAxyfosYxbr5
         ynuJfoKG6dT1XPINTo/9WNoMJzCQIGjTAQ70coLzW1jB77s4bA6Dk7AoMzOi6r+NtMpN
         7Q9TESgxQofHupVJHJVy5MWfpf4NoGVikIdNKnisWVzPbqT1HtzmL/iAcvpoR6hfAlSM
         +5QeKJLh6L/s2Ppn6AFNiXKxA2YnqqxLPzGBz0BuizAbOGCOzVDhY58ckRBYxmAl07Wo
         AsQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=P0a3IxWEVQPFjkIc4Dl1ocM+hJArqq5maEnC33gmLjY=;
        fh=YVl3G/dcEeUZwAdyUOUIoIM5e1Tk98CNlsDOskxwVZk=;
        b=j8Is1IMm6QomJvwf4VMjykP1NFD2W1oiiKQ1c2c8ZIPY1daF25kdqn5ESjgJWag1pB
         lLvOzg2yG/DTYagmBOQqGTqRdbDK5sSBky6g9CFGCB/tD++JQC8sL06NOgpOQHrbslC9
         YXcQOY5TAG59w6LY4P/88VZxwx83MGSF744qnwae9KXaSNYaL9SNNKl4Plg2ZuJhaYID
         aGaIACzc33gcJelNTbVUTBCcYyoQ3zotQhgBvnHZr6mdw+sYKy/otnRO7nO/xc3t7KNn
         nXrojuOhZaf+dlDNKcna/G/KdJFhos9TTwWb/ONjPE8K/HfMqPRdeA0dXwEd1F2eEKTG
         xpPg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783354140; x=1783958940; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=P0a3IxWEVQPFjkIc4Dl1ocM+hJArqq5maEnC33gmLjY=;
        b=BgGhwC3cqdHXyuYVOrrrchs6YBnGmnzWa1TPxpud0th8x9OatMcuYlXW9Ib0uxU2Yz
         oJynerDnB8w5c+I0YgDg7XaGh+NwQFa/i7OMfx9+3Lzx7o9th8eJALcHPQPPvDQMQ49n
         xj7elmDPLmHiSdQU1xI1KD7xaA3N3Zye+7kPga86kILO60mgBNf0Cn0blXFuDY0hlqbR
         dz6Av+Kxa9i3+cft6/yzLk7Zjt0zBZrHjdE6h6ZZOsVO4AUp/aBKMfhfYnhCYehZgMGI
         UYdwZnr2gHOX9IQ2xc2EiWLZzVHidyAuVNgTFS8g2ozzcptAoKYh/8pk7FC5Z1uMEHWA
         knlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783354140; x=1783958940;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P0a3IxWEVQPFjkIc4Dl1ocM+hJArqq5maEnC33gmLjY=;
        b=a9GiJElVdYKzsoWH1+qa/B/fLQER/ptRoKQbvDOeIIWpbLjNzXyGaSTX6ESrE2ALLx
         f4eG20a0QnyUGzSoRmAOCRkNI1aDW/LsLlvV+KEosNpPDh2UhxHf/F5Lpz58vkmek56d
         jXdHQ2pSmhqsoLmAqo1bAQE3OucnZf2aC4eF2J8YofbErngBjldxkiGZ4vUCymtxy36s
         ly1PvSb0Fw8xg+CgQd8IEZfYCahYo5cJKA+rfN2nCq+0loZq660/H39fJvL/cny7PSZM
         k3vJ9xuVE5smuYGbtRxKVGLpn4sHd8v4tWEZ3NWLqG9HG45SR13J/ztgj/eWeFfSLRXK
         IC7g==
X-Gm-Message-State: AOJu0Yxr6DIVwWdbXU8S919ATroSJavCmxO37Une8jRn9SVNACgFjNtV
	+SBU1LLQUNPGEz16Klb+DFwHtJfzv+j2TAqc0Dav01P3e2ypcUu+mP+CqkUEFoKbCPDayGOreHU
	NIpanOCR+KbC8bYTrSb6dCbRA56czKCw=
X-Gm-Gg: AfdE7clQJadVeoJd5iHa6ZIhlP2ATEYjj3Kq4VtcYqERLzbVWYtTtenPJLqxXAYpr0C
	FTM8xcoTIN013JJzM2rJFXnUAPJMPhUJkGO4kHLg2oLp/FmNp8Crb8DfWkApqeJKVpGEfEwcaKu
	Wwp8HFVniKRuavfHhMdRLvsio/YvSBQEwctb37OT7q8tKsbwm7wIJZbyL0nQ07zsNPXUDQm8LGw
	GbS5CIVRhzBPcYvkytTFvAehSAW2ZrrIPkOp5KiBAyNdW/zjxEI7brtRhQk8ddbUlJFEKeMenQy
	wSQqtEXWvejAzmkDganpCFbHQcACdzZ7yA12VHPBP54hh4GaK23R50Cr1lAB/2VKcdE0rPnNRoF
	8ogI4dARgtzTlpls6iIUHtlDbXgyZab40tm1l/RRF5ZemPeiGsebmsnhOYl0ZnVy0x7uCfbHPWN
	JEfrX9XX5MXSTzKdm9nB/vPA==
X-Received: by 2002:a05:6214:411:b0:8e9:f62b:8f8d with SMTP id
 6a1803df08f44-8fcb4ef2cc0mr13761636d6.51.1783354139302; Mon, 06 Jul 2026
 09:08:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260706153212.839012-1-ematsumiya@suse.de>
In-Reply-To: <20260706153212.839012-1-ematsumiya@suse.de>
From: Steve French <smfrench@gmail.com>
Date: Mon, 6 Jul 2026 11:08:45 -0500
X-Gm-Features: AVVi8CdIewtubGy_C3DoH7f9ZwhAiXTMCEf0OSOq7kaBYsTvHMp5pTlnsd2eDDw
Message-ID: <CAH2r5mvir3A-H4j1PcPK9v4kNdP2h6hf+OZSUPj3DzkJ=q62xQ@mail.gmail.com>
Subject: Re: [PATCH v2] cifs.upcall: fix regression with krb5 + creduid
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org, 
	Steve French <stfrench@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into smb3-utils for-next

On Mon, Jul 6, 2026 at 10:32=E2=80=AFAM Enzo Matsumiya <ematsumiya@suse.de>=
 wrote:
>
> Commit 972c5b5ff95e ("cifs.upcall: remove getpwuid() dependency")
> introduced a regression when using creduid !=3D uid (e.g.
> "mount.cifs -o sec=3Dkrb5,cruid=3DX"), so 'uid' local var is replaced
> with procfs "Uid" value (in the example, the one from mount.cifs).
>
> That commit ignored the fact that:
>   mount UID can be different from creds UID, and that calling-app
>   process (post-mount) can be different from both
>
> This patch "reverts" 972c5b5ff95e ("cifs.upcall: remove getpwuid()
> dependency"); transform the "emergency"-added function get_uidgid()
> into map_uidgid(), now only used to do NS UID/GID mapping.
>
> Also add getpwuid() back, but this time called while still on host
> namespace, so any possible custom NSS module is ran as allowed by
> sysadmin.
>
> Any scenario involving unmapped UIDs or GIDs is unsupported; this
> means that any UID:GID in a child user namespace _must_ map back to
> a valid and existing host UID:GID.
>
> Fixes: 972c5b5ff95e ("cifs.upcall: remove getpwuid() dependency")
> Reported-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---
> v2:
> - map_id(): moved 'errno =3D EINVAL' to the failure blocks and 'errno =3D=
 0'
>   explicitly into success block, because apparently fscanf() only resets
>   errno on glibc
> - change range checks and NS mapping to use *idp instead of 'id' (so
>   further possible duplicates are found correctly)
> - fix errno save/restore on fclose()
> - log correct errno if getpwuid() returns NULL; but leaves it as is,
>   even if it's 0 (we're exiting anyway)
>
>
>  cifs.upcall.c | 279 ++++++++++++++++++++++++++++++++------------------
>  1 file changed, 177 insertions(+), 102 deletions(-)
>
> diff --git a/cifs.upcall.c b/cifs.upcall.c
> index 11dbc6186a74..ff5f68f55692 100644
> --- a/cifs.upcall.c
> +++ b/cifs.upcall.c
> @@ -52,6 +52,7 @@
>  #include <arpa/inet.h>
>  #include <ctype.h>
>  #include <grp.h>
> +#include <pwd.h>
>  #include <stdbool.h>
>  #include <errno.h>
>  #include <sched.h>
> @@ -1375,118 +1376,170 @@ static int ip_to_fqdn(const char *addrstr, char=
 *host, size_t hostlen)
>         return 0;
>  }
>
> -/* cover worst case/impossible scenarios */
> -#define PROC_PID_PATH_MAXLEN   ((int)sizeof("/proc/2147483647/status"))
> -/* max valid UID/GID is (UINT_MAX - 1) */
> -#define INVALID_UIDGID         UINT_MAX
> +#define ID_MAP_PATH_MAX ((int)sizeof("/proc/2147483647/uid_map"))
>
> -/*
> - * get_uidgid - Get @pid's (real) UID and/or GID.
> - * @pid: process to get UID/GID from
> - * @uidp: pointer to store @pid's UID (can be NULL)
> - * @gidp: pointer to store @pid's GID (can be NULL)
> - *
> - * Extract "Uid:" and "Gid:" fields from /proc/@pid/status.
> - * Do so based on whether @uidp or @gidp are NULL.
> - *
> - * This function assumes we're on the same namespace as @pid.
> - *
> - * Return: 0 on success, -1 otherwise (errno set).
> - *
> - * On errors, *@uidp and *@gidp are set to INVALID_UIDGID.
> - */
> -static int get_uidgid(pid_t pid, uid_t *uidp, gid_t *gidp)
> +static int map_id(pid_t pid, const char *map, unsigned int *idp)
>  {
> -       char path[PROC_PID_PATH_MAXLEN] =3D {}, buf[256];
> +       unsigned long long ns_start, host_start, range;
> +       char map_path[ID_MAP_PATH_MAX];
> +       int map_path_size =3D sizeof(map_path);
> +       unsigned int id;
>         FILE *fp =3D NULL;
> -       int ret;
> -
> -       errno =3D 0;
> -       if (pid < 0 || (!uidp && !gidp)) {
> -               errno =3D EINVAL;
> -               return -1;
> -       }
> -
> -       if (uidp)
> -               *uidp =3D INVALID_UIDGID;
> +       int ret =3D 1;
>
> -       if (gidp)
> -               *gidp =3D INVALID_UIDGID;
> +       errno =3D EINVAL;
> +       if (pid < 0 || !map || !idp || *idp =3D=3D UINT_MAX)
> +               goto out;
>
> -       ret =3D snprintf(path, PROC_PID_PATH_MAXLEN, "/proc/%d/status", p=
id);
> -       if (ret < 0 || ret >=3D PROC_PID_PATH_MAXLEN) {
> -               if (!errno)
> +       ret =3D snprintf(map_path, map_path_size, "/proc/%d/%s", pid, map=
);
> +       if (ret < 0 || ret >=3D map_path_size) {
> +               if (ret >=3D map_path_size)
>                         errno =3D ENAMETOOLONG;
> -               return -1;
> +               ret =3D 1;
> +               goto out;
>         }
>
> -       fp =3D fopen(path, "r");
> -       if (!fp) {
> -               ret =3D -1;
> +       ret =3D 1;
> +       fp =3D fopen(map_path, "r");
> +       if (!fp)
>                 goto out;
> -       }
>
> -       /* Parse /proc/pid/status fields */
> -       errno =3D 0;
> -       ret =3D -1;
> -       while (fgets(buf, 256, fp)) {
> -               unsigned long long val;
> +       /*
> +        * The map files have the same format:
> +        *   <NS ID start> <host ID start> <range>
> +        *   ... (<multiple entries are supported) ...
> +        *
> +        * Formula and validation:
> +        *   <final NS ID> =3D (*@idp - <host ID start>) + <NS ID start>
> +        *
> +        * - IDs: [0, UINT_MAX - 1]
> +        * - range: [1, UINT_MAX], where range =3D=3D UINT_MAX requires b=
oth ID ranges to start at 0,
> +        *   which then means this is an init host NS mapping (and that's=
 ok)
> +        *
> +        * The formula itself would be enough to "validate" a matching NS=
 ID, but we don't want to
> +        * keep parsing a malformed map file, no matter how unlikely/impo=
ssible it is to happen.
> +        * Same reason values are parsed as 'unsigned long long', so we c=
an check for bogus data.
> +        */
> +       id =3D UINT_MAX;
> +       errno =3D ENODATA;
> +       while (fscanf(fp, "%llu %llu %llu", &ns_start, &host_start, &rang=
e) =3D=3D 3) {
> +               if (ns_start >=3D UINT_MAX || host_start >=3D UINT_MAX ||
> +                   range > UINT_MAX || range =3D=3D 0) {
> +                       errno =3D EINVAL;
> +                       ret =3D 1;
> +                       break;
> +               }
>
> -               errno =3D ENODATA;
> -               if ((!uidp || strncmp(buf, "Uid:", 4)) && (!gidp || strnc=
mp(buf, "Gid:", 4)))
> -                       continue;
> +               if (range =3D=3D UINT_MAX && (ns_start !=3D 0 || host_sta=
rt !=3D 0)) {
> +                       errno =3D EINVAL;
> +                       ret =3D 1;
> +                       break;
> +               }
>
> -               errno =3D 0;
> +               if (host_start + range > UINT_MAX) {
> +                       errno =3D EINVAL;
> +                       ret =3D 1;
> +                       break;
> +               }
>
>                 /*
> -                * Example line format (same for both Uid/Gid):
> -                * "Uid:\t%u\t%u\%u\%u"
> +                * Check if host ID fits this line.
> +                * Our desired NS ID may be in any line of the file.
>                  *
> -                * Where the numbers represents:
> -                * <real> <effective> <saved> <fsuid>
> +                * Note: new{uid,gid}map tools (that creates the map file=
s) don't allow multiple
> +                * maps (NS IDs) to the same host ID.
>                  *
> -                * We're only interested in the <real> value.
> +                * If we get a match here, we'll save it, but we continue=
 parsing the file.
> +                * If we happen to find a duplicate, it's possible this i=
s a rogue file trying to
> +                * bypass these checks.
>                  *
> -                * (field names "Uid:"/"Gid:" parsed above, skip it)
> +                * In such cases, discard the match and return EOPNOTSUPP=
, as returning a
> +                * successful match could lead to disastrous results.
>                  */
> -               ret =3D sscanf(&buf[0] + 4, "%llu", &val);
> -               if (ret !=3D 1) {
> -                       ret =3D -1;
> -                       if (errno)
> +               if (*idp >=3D host_start && *idp < host_start + range) {
> +                       /* This means we found a duplicate */
> +                       if (!ret) {
> +                               ret =3D 1;
> +                               errno =3D EOPNOTSUPP;
> +                               syslog(LOG_ERR, "%s has multiple mapped I=
Ds for %u (unsupported)",
> +                                      map, *idp);
>                                 break;
> -                       continue;
> -               }
> -
> -               ret =3D -1;
> -               if (val >=3D UINT_MAX) {
> -                       errno =3D EINVAL;
> -                       break;
> -               }
> -
> -               if (uidp && !strncmp(buf, "Uid:", 4))
> -                       *uidp =3D (uid_t)val;
> -               else
> -                       *gidp =3D (gid_t)val;
> +                       }
>
> -               if ((!uidp || *uidp !=3D INVALID_UIDGID) && (!gidp || *gi=
dp !=3D INVALID_UIDGID)) {
> -                       errno =3D 0;
> +                       id =3D (*idp - host_start) + ns_start;
>                         ret =3D 0;
> -                       break;
> +                       errno =3D 0;
>                 }
>         }
> +
> +       /* This means errno was reset by fscanf() without finding anythin=
g */
> +       if (ret && errno =3D=3D 0)
> +               errno =3D ENODATA;
>  out:
> -       if (fp)
> +       if (fp) {
> +               int err =3D errno;
> +
>                 fclose(fp);
> +               /* Ignore fclose() errors */
> +               errno =3D err;
> +       }
>
> -       if (ret) {
> -               syslog(LOG_DEBUG, "%s(pid=3D%d): %s", __func__, pid, stre=
rror(errno));
> -               if (uidp)
> -                       *uidp =3D INVALID_UIDGID;
> +       if (!ret) {
> +               *idp =3D id;
> +               errno =3D 0;
> +       } else {
> +               syslog(LOG_DEBUG, "%s(pid=3D%d, map=3D%s, id=3D%u): %s", =
__func__, pid, map, *idp,
> +                      strerror(errno));
> +       }
>
> -               if (gidp)
> -                       *gidp =3D INVALID_UIDGID;
> +       return ret;
> +}
> +
> +/*
> + * map_uidgid() - Map (real) UID/GID from init host NS to user NS.
> + * @pid: host NS PID
> + * @uidp: (in) host UID, (out) NS UID
> + * @gidp: (in) host GID, (out) NS GID
> + *
> + * Parse /proc/@pid/{uid,gid}_map files to get NS UID/GID values.
> + * Since @pid is expected to be a host NS PID, this must be called befor=
e switching namespaces.
> + *
> + * Note: we can't use /proc/self here because we haven't switched NS yet=
, so {uid,gid}_map files
> + * would contain host NS values.
> + *
> + * Return: 0 on success, 1 otherwise (errno set).
> + */
> +static int map_uidgid(pid_t pid, uid_t *uidp, gid_t *gidp)
> +{
> +       uid_t orig_uid;
> +       gid_t orig_gid;
> +       int ret =3D 1;
> +
> +       errno =3D EINVAL;
> +       if (!uidp || !gidp)
> +               goto out;
> +
> +       orig_uid =3D *uidp;
> +       orig_gid =3D *gidp;
> +
> +       ret =3D map_id(pid, "uid_map", uidp);
> +       if (ret) {
> +               if (errno =3D=3D ENODATA)
> +                       syslog(LOG_ERR, "UID %u not mapped in this namesp=
ace (unsupported)",
> +                              orig_uid);
> +               goto out;
>         }
>
> +       ret =3D map_id(pid, "gid_map", gidp);
> +       if (ret && errno =3D=3D ENODATA)
> +               syslog(LOG_ERR, "GID %u not mapped in this namespace (uns=
upported)",
> +                      orig_gid);
> +out:
> +       if (ret && errno !=3D ENODATA)
> +               syslog(LOG_ERR, "%s: %s", __func__, strerror(errno));
> +       else if (!ret)
> +               syslog(LOG_DEBUG, "host %u:%u -> NS %u:%u", orig_uid, ori=
g_gid, *uidp, *gidp);
> +
>         return ret;
>  }
>
> @@ -1534,6 +1587,7 @@ int main(const int argc, char *const argv[])
>         const char *oid;
>         uid_t uid;
>         gid_t gid;
> +       struct passwd *pw;
>         char *keytab_name =3D NULL;
>         char *env_cachename =3D NULL;
>         krb5_ccache ccache =3D NULL;
> @@ -1680,12 +1734,52 @@ int main(const int argc, char *const argv[])
>                 goto out;
>         }
>
> +       /*
> +        * 'uid' always points to a host UID, so we must get the correspo=
nding host GID.
> +        * It's safe to call getpwuid() here because we're still on host =
NS, i.e. caller
> +        * application has no control over custom NSS modules.
> +        *
> +        * FIXME: if UID is from another NS, or a subuid, this will fail =
on mount.
> +        */
> +       errno =3D 0;
> +       pw =3D getpwuid(uid);
> +       if (!pw) {
> +               syslog(LOG_ERR, "failed to retrieve GID from UID %u: %s",=
 uid,
> +                      strerror(errno ?: ENOENT));
> +               rc =3D 1;
> +               goto out;
> +       }
> +
> +       gid =3D pw->pw_gid;
> +
> +       /*
> +        * We can't reasonably do this for root. When mounting a DFS shar=
e,
> +        * for instance we can end up with creds being overridden, but th=
e env
> +        * variable left intact.
> +        *
> +        * Always check this before NS UID mapping.
> +        */
> +       if (uid =3D=3D 0)
> +               env_probe =3D false;
> +
>         /*
>          * Change to the process's namespace. This means that things will=
 work
>          * acceptably in containers, because we'll be looking at the corr=
ect
>          * filesystem and have the correct network configuration.
>          */
>         if (arg->upcall_target =3D=3D UPTARGET_APP || arg->upcall_target =
=3D=3D UPTARGET_UNSPECIFIED) {
> +               /*
> +                * Map host 'uid' and 'gid' to the target user NS.
> +                *
> +                * Any scenario that involves unmapped UIDs or primary GI=
Ds is not supported -- we
> +                * don't have, and can't find, all the info that would be=
 necessary to find a
> +                * UID/GID within all the possible NS combinations.
> +                */
> +               if (!in_same_user_ns(arg->pid, getpid())) {
> +                       rc =3D map_uidgid(arg->pid, &uid, &gid);
> +                       if (rc)
> +                               goto out;
> +               }
>                 syslog(LOG_INFO, "upcall_target=3Dapp, switching namespac=
es to application thread");
>                 arg->upcall_target =3D UPTARGET_APP;
>                 rc =3D switch_to_process_ns(arg->pid);
> @@ -1700,25 +1794,6 @@ int main(const int argc, char *const argv[])
>                 syslog(LOG_INFO, "upcall_target=3Dmount, not switching na=
mespaces to application thread");
>         }
>
> -       /*
> -        * We can't reasonably do this for root. When mounting a DFS shar=
e,
> -        * for instance we can end up with creds being overridden, but th=
e env
> -        * variable left intact.
> -        */
> -       if (uid =3D=3D 0)
> -               env_probe =3D false;
> -
> -       /*
> -        * FIXME: this only works if we haven't switched PID namespaces.
> -        * If we did, /proc/arg->pid/ might not exist, or worse, point to=
 something else.
> -        */
> -       rc =3D get_uidgid(arg->pid, &uid, &gid);
> -       if (rc) {
> -               syslog(LOG_ERR, "get_uidgid (NS): %s", strerror(errno));
> -               rc =3D 1;
> -               goto out;
> -       }
> -
>         rc =3D setgid(gid);
>         if (rc) {
>                 syslog(LOG_ERR, "setgid: %s", strerror(errno));
> --
> 2.54.0
>


--=20
Thanks,

Steve
