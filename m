Return-Path: <SRS0=ymiT=25=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D020C282DD
	for <linux-cifs@archiver.kernel.org>; Wed,  8 Jan 2020 20:42:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA3F020692
	for <linux-cifs@archiver.kernel.org>; Wed,  8 Jan 2020 20:42:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m9EkVZ+J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgAHUmP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 8 Jan 2020 15:42:15 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:37061 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbgAHUmP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 8 Jan 2020 15:42:15 -0500
Received: by mail-lf1-f65.google.com with SMTP id b15so3478665lfc.4
        for <linux-cifs@vger.kernel.org>; Wed, 08 Jan 2020 12:42:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kKEzVTP95pC4pqtTZBMDOfXbPUmu1N/3x0vFJ2+cdD4=;
        b=m9EkVZ+J5p4rbO8jAbN/ook9KmAIRM2JmAbiWyxD5Jm23E9Z5MpJN+vZvPOYg3QSro
         1VKb46t+BsIvUtVJ8L3mI0MpYVU0JRtUYTk7nSiBMuaNV8TzwbtXwb/yZemuU98V83Gv
         SM2CQdWkqmjVvaI2cd/b1QsruYA9b0oZXkFIdX0KaA0re6Dm6r7Vm+1s9CV8WjFY4XgJ
         LgTx3fAicbwxmsFxbB4CvgscMHxq1oemOhzDSdNegoMU6NCJxFuD8bhTzaws0UCKlaj+
         idLHusawrvcKazZxu83uVCsgvHSL4o1ne7OUiKxIpKL25Jj391Z5zWC4mkQRsA5KKBh8
         IQ6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kKEzVTP95pC4pqtTZBMDOfXbPUmu1N/3x0vFJ2+cdD4=;
        b=WGy51Hgjt26FK8a6KtNiCgYKk3bFFMR5gY+cIyeOc//Sdvoow2YVfgP8QMjqzvb/TZ
         JNGVm9wgpMVJo3hs1GzZncC66s6WnvW0oSH6xdNaGNwnseCDp6QAYndF66TZIFQb5jpF
         ypAeoQbioKuM2gsku3NLiy/9MlSgb6OF2EihJId8qYLIlAt5hJWuRawKt7nPONTbdkyv
         hKrau+NDCaW2MIEfv48L4kyz8njP/W1eHmeyqzTQtA3aQk8GiuYA1/pxkt26tecH9Vqn
         zX8nb2E8fwk/iOeN6HRc2NtSx6F7gOzUHvsXUjORUqWYHCMXbPz1/JfCFmzGUJxhvtc2
         YTaA==
X-Gm-Message-State: APjAAAXhGHSsSr+H53ALqhPTXOAIk2HcXBfHV9Igqp1v6KQscO5mktlN
        Wil2zwIgBp7zLOGx6fKqxeY5paRxeanLkK6eBQ==
X-Google-Smtp-Source: APXvYqxCwXJo7RhAOlEanynsZnBlOXghnEQe2pUJDU8Ys+qetOpdApAD4w1LReoO1Q98IVY94plhJer4Br8+QMgLez4=
X-Received: by 2002:a19:c697:: with SMTP id w145mr3900359lff.54.1578516131662;
 Wed, 08 Jan 2020 12:42:11 -0800 (PST)
MIME-Version: 1.0
References: <20200106163119.9083-1-boris.v.protopopov@gmail.com> <20200106163119.9083-2-boris.v.protopopov@gmail.com>
In-Reply-To: <20200106163119.9083-2-boris.v.protopopov@gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 8 Jan 2020 12:42:00 -0800
Message-ID: <CAKywueSK-_zzF-K3_ehmLT3yje_hGaQU-1z-G3hYugMv3ZV-eA@mail.gmail.com>
Subject: Re: [PATCH] Add support for setting owner and group in ntsd
To:     Boris Protopopov <boris.v.protopopov@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        samba-technical <samba-technical@lists.samba.org>,
        sblbir@amazon.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D0=BD, 6 =D1=8F=D0=BD=D0=B2. 2020 =D0=B3. =D0=B2 08:31, Boris Protop=
opov <boris.v.protopopov@gmail.com>:
>
> Extend setcifsacl utility to allow setting owner and group SIDs
> in the security descriptor in addition to setting ACLs. This is
> a user-friendly intefrace for setting owner and group SIDs that
> takes advantage of the recent extensions in the CIFS kernel
> client, and it complements setting raw values via setfattr.
>
> Signed-off-by: Boris Protopopov <boris.v.protopopov@gmail.com>

Thanks for the patch. Could you clarify which recent changes in the
CIFS kernel client are referenced in the patch description?

> ---
>  cifsacl.h         |   4 +-
>  setcifsacl.c      | 253 ++++++++++++++++++++++++++++++++++++++++++++----=
------
>  setcifsacl.rst.in |  27 ++++--
>  3 files changed, 235 insertions(+), 49 deletions(-)
>
> diff --git a/cifsacl.h b/cifsacl.h
> index ca72dd4..bd0c695 100644
> --- a/cifsacl.h
> +++ b/cifsacl.h
> @@ -26,7 +26,9 @@
>  #define _CIFSACL_H
>
>  #define BUFSIZE 1024
> -#define ATTRNAME "system.cifs_acl"
> +#define ATTRNAME       "system.cifs_acl"
> +#define ATTRNAME_ACL   ATTRNAME
> +#define ATTRNAME_NTSD  "system.cifs_ntsd"
>
>  #define MAX_NUM_AUTHS 6
>
> diff --git a/setcifsacl.c b/setcifsacl.c
> index 9a301e2..6e5a633 100644
> --- a/setcifsacl.c
> +++ b/setcifsacl.c
> @@ -44,7 +44,9 @@ enum setcifsacl_actions {
>         ActDelete,
>         ActModify,
>         ActAdd,
> -       ActSet
> +       ActSetAcl,
> +       ActSetOwner,
> +       ActSetGroup
>  };
>
>  static void *plugin_handle;
> @@ -140,6 +142,90 @@ copy_sec_desc(const struct cifs_ntsd *pntsd, struct =
cifs_ntsd *pnntsd,
>         return bufsize;
>  }
>
> +/*
> + * This function (and the one above) does not need to set the SACL-relat=
ed
> + * fields, and this works fine because on the SMB protocol level, settin=
g owner
> + * info, DACL, and SACL requires one to use separate flags that control =
which
> + * part of the descriptor is begin looked at on the server side
> + */
> +static ssize_t
> +copy_sec_desc_with_sid(const struct cifs_ntsd *pntsd, struct cifs_ntsd *=
pnntsd,
> +               struct cifs_sid *sid, int maction)
> +{
> +       int size, daclsize;
> +       int osidoffset, gsidoffset, dacloffset;
> +       int nosidoffset, ngsidoffset, ndacloffset, nsidssize;
> +       ssize_t bufsize;
> +       struct cifs_sid *owner_sid_ptr, *group_sid_ptr;
> +       struct cifs_sid *nowner_sid_ptr, *ngroup_sid_ptr;
> +       struct cifs_ctrl_acl *dacl_ptr, *ndacl_ptr;
> +
> +       /* copy security descriptor control portion */
> +       osidoffset =3D le32toh(pntsd->osidoffset);
> +       gsidoffset =3D le32toh(pntsd->gsidoffset);
> +       dacloffset =3D le32toh(pntsd->dacloffset);
> +       /*
> +        * the size of the owner or group sid might be different from the=
 old
> +        * one, so the group sid offest might change, and if the owner is
> +        * positioned before the DACL, the dacl offset might change as we=
ll;
> +        * note however, that the owner sid offset does not change
> +        */
> +       nosidoffset =3D osidoffset;
> +       size =3D sizeof(struct cifs_ntsd);
> +       pnntsd->revision =3D pntsd->revision;
> +       pnntsd->type =3D pntsd->type;
> +       pnntsd->osidoffset =3D pntsd->osidoffset;
> +       bufsize =3D size;
> +
> +       /* set the pointers for source sids */
> +       if (maction =3D=3D ActSetOwner) {
> +               owner_sid_ptr =3D sid;
> +               group_sid_ptr =3D (struct cifs_sid *)((char *)pntsd + gsi=
doffset);
> +       }
> +       if (maction =3D=3D ActSetGroup) {
> +               owner_sid_ptr =3D (struct cifs_sid *)((char *)pntsd + osi=
doffset);
> +               group_sid_ptr =3D sid;
> +       }
> +
> +       dacl_ptr =3D (struct cifs_ctrl_acl *)((char *)pntsd + dacloffset)=
;
> +       daclsize =3D le16toh(dacl_ptr->size) + sizeof(struct cifs_ctrl_ac=
l);
> +
> +       /* copy owner sid */
> +       nowner_sid_ptr =3D (struct cifs_sid *)((char *)pnntsd + nosidoffs=
et);
> +       size =3D copy_cifs_sid(nowner_sid_ptr, owner_sid_ptr);
> +       bufsize +=3D size;
> +       nsidssize =3D size;
> +
> +       /* copy group sid */
> +       ngsidoffset =3D nosidoffset + size;
> +       ngroup_sid_ptr =3D (struct cifs_sid *)((char *)pnntsd + ngsidoffs=
et);
> +       pnntsd->gsidoffset =3D htole32(ngsidoffset);
> +       size =3D copy_cifs_sid(ngroup_sid_ptr, group_sid_ptr);
> +       bufsize +=3D size;
> +       nsidssize +=3D size;
> +
> +       /* position the dacl control info as in the fetched descriptor */
> +       if (dacloffset <=3D osidoffset)
> +               ndacloffset =3D dacloffset;
> +       else
> +               ndacloffset =3D nosidoffset + nsidssize;
> +       ndacl_ptr =3D (struct cifs_ctrl_acl *)((char *)pnntsd + ndacloffs=
et);
> +       pnntsd->dacloffset =3D htole32(ndacloffset);
> +
> +       /* the DACL control fields do not change */
> +       ndacl_ptr->revision =3D dacl_ptr->revision;
> +       ndacl_ptr->size =3D dacl_ptr->size;
> +       ndacl_ptr->num_aces =3D dacl_ptr->num_aces;
> +
> +       /*
> +        * add DACL size (control portion and the array of aces) to the
> +        * buffer size
> +        */
> +       bufsize +=3D daclsize;
> +
> +       return bufsize;
> +}
> +
>  static int
>  copy_ace(struct cifs_ace *dace, struct cifs_ace *sace)
>  {
> @@ -788,7 +874,7 @@ setacl_action(struct cifs_ntsd *pntsd, struct cifs_nt=
sd **npntsd,
>                 rc =3D ace_add(pntsd, npntsd, bufsize, facesptr,
>                                 numfaces, cacesptr, numcaces);
>                 break;
> -       case ActSet:
> +       case ActSetAcl:
>                 rc =3D ace_set(pntsd, npntsd, bufsize, cacesptr, numcaces=
);
>                 break;
>         default:
> @@ -803,9 +889,10 @@ static void
>  setcifsacl_usage(const char *prog)
>  {
>         fprintf(stderr,
> -       "%s: Alter CIFS/NTFS ACL in a security descriptor of a file objec=
t\n",
> +       "%s: Alter CIFS/NTFS ACL or owner/group in a security descriptor =
of a file object\n",
> +               prog);
> +       fprintf(stderr, "Usage: %s option [<list_of_ACEs>|<SID>] <file_na=
me>\n",
>                 prog);
> -       fprintf(stderr, "Usage: %s option <list_of_ACEs> <file_name>\n", =
prog);
>         fprintf(stderr, "Valid options:\n");
>         fprintf(stderr, "\t-v   Version of the program\n");
>         fprintf(stderr, "\n\t-a Add ACE(s), separated by a comma, to an A=
CL\n");
> @@ -825,21 +912,32 @@ setcifsacl_usage(const char *prog)
>         "\n\t-S Replace existing ACL with ACE(s), separated by a comma\n"=
);
>         fprintf(stderr,
>         "\tsetcifsacl -S \"ACL:Administrator:ALLOWED/0x0/D\" <file_name>\=
n");
> +       fprintf(stderr,
> +       "\n\t-o Set owner using specified SID (name or raw format)\n");
> +       fprintf(stderr,
> +       "\tsetcifsacl -o \"Administrator\" <file_name>\n");
> +       fprintf(stderr,
> +       "\n\t-g Set group using specified SID (name or raw format)\n");
> +       fprintf(stderr,
> +       "\tsetcifsacl -g \"Administrators\" <file_name>\n");
>         fprintf(stderr, "\nRefer to setcifsacl(1) manpage for details\n")=
;
>  }
>
>  int
>  main(const int argc, char *const argv[])
>  {
> -       int i, rc, c, numcaces, numfaces;
> +       int i, rc, c, numcaces =3D 0, numfaces =3D 0;
>         enum setcifsacl_actions maction =3D ActUnknown;
>         ssize_t attrlen, bufsize =3D BUFSIZE;
> -       char *ace_list, *filename, *attrval, **arrptr =3D NULL;
> +       char *ace_list =3D NULL, *filename =3D NULL, *attrval =3D NULL,
> +               **arrptr =3D NULL, *sid_str =3D NULL;
>         struct cifs_ctrl_acl *daclptr =3D NULL;
>         struct cifs_ace **cacesptr =3D NULL, **facesptr =3D NULL;
>         struct cifs_ntsd *ntsdptr =3D NULL;
> +       struct cifs_sid sid;
> +       char *attrname =3D ATTRNAME_ACL;
>
> -       c =3D getopt(argc, argv, "hvD:M:a:S:");
> +       c =3D getopt(argc, argv, "hvD:M:a:S:o:g:");
>         switch (c) {
>         case 'D':
>                 maction =3D ActDelete;
> @@ -854,9 +952,19 @@ main(const int argc, char *const argv[])
>                 ace_list =3D optarg;
>                 break;
>         case 'S':
> -               maction =3D ActSet;
> +               maction =3D ActSetAcl;
>                 ace_list =3D optarg;
>                 break;
> +       case 'o':
> +               maction =3D ActSetOwner;
> +               sid_str =3D optarg;
> +               attrname =3D ATTRNAME_NTSD;
> +               break;
> +       case 'g':
> +               maction =3D ActSetGroup;
> +               sid_str =3D optarg;
> +               attrname =3D ATTRNAME_NTSD;
> +               break;
>         case 'h':
>                 setcifsacl_usage(basename(argv[0]));
>                 return 0;
> @@ -875,11 +983,16 @@ main(const int argc, char *const argv[])
>         }
>         filename =3D argv[3];
>
> -       if (!ace_list) {
> +       if (!ace_list && maction !=3D ActSetOwner && maction !=3D ActSetG=
roup) {
>                 printf("%s: No valid ACEs specified\n", __func__);
>                 return -1;
>         }
>
> +       if (!sid_str && (maction =3D=3D ActSetOwner || maction =3D=3D Act=
SetGroup)) {
> +               printf("%s: No valid SIDs specified\n", __func__);
> +               return -1;
> +       }
> +
>         if (init_plugin(&plugin_handle)) {
>                 fprintf(stderr, "WARNING: unable to initialize idmapping =
"
>                                 "plugin. Only \"raw\" SID strings will be=
 "
> @@ -889,16 +1002,24 @@ main(const int argc, char *const argv[])
>                 plugin_loaded =3D true;
>         }
>
> -       numcaces =3D get_numcaces(ace_list);
> -
> -       arrptr =3D parse_cmdline_aces(ace_list, numcaces);
> -       if (!arrptr)
> -               goto setcifsacl_numcaces_ret;
> +       if (maction =3D=3D ActSetOwner || maction =3D=3D ActSetGroup) {
> +               /* parse the sid */
> +               if (setcifsacl_str_to_sid(sid_str, &sid)) {
> +                       printf("%s: failed to parce \'%s\' as SID\n", __f=
unc__,
> +                               sid_str);
> +                       goto setcifsacl_numcaces_ret;
> +               }
> +       } else {
> +               numcaces =3D get_numcaces(ace_list);
>
> -       cacesptr =3D build_cmdline_aces(arrptr, numcaces);
> -       if (!cacesptr)
> -               goto setcifsacl_cmdlineparse_ret;
> +               arrptr =3D parse_cmdline_aces(ace_list, numcaces);
> +               if (!arrptr)
> +                       goto setcifsacl_numcaces_ret;
>
> +               cacesptr =3D build_cmdline_aces(arrptr, numcaces);
> +               if (!cacesptr)
> +                       goto setcifsacl_cmdlineparse_ret;
> +       }
>  cifsacl:
>         if (bufsize >=3D XATTR_SIZE_MAX) {
>                 printf("%s: Buffer size %zd exceeds max size of %d\n",
> @@ -912,7 +1033,7 @@ cifsacl:
>                 goto setcifsacl_cmdlineverify_ret;
>         }
>
> -       attrlen =3D getxattr(filename, ATTRNAME, attrval, bufsize);
> +       attrlen =3D getxattr(filename, attrname, attrval, bufsize);
>         if (attrlen =3D=3D -1) {
>                 if (errno =3D=3D ERANGE) {
>                         free(attrval);
> @@ -924,26 +1045,64 @@ cifsacl:
>                 }
>         }
>
> -       numfaces =3D get_numfaces((struct cifs_ntsd *)attrval, attrlen, &=
daclptr);
> -       if (!numfaces && maction !=3D ActAdd) { /* if we are not adding a=
ces */
> -               printf("%s: Empty DACL\n", __func__);
> -               goto setcifsacl_facenum_ret;
> -       }
> +       if (maction =3D=3D ActSetOwner || maction =3D=3D ActSetGroup) {
> +               struct cifs_ntsd *pfntsd =3D (struct cifs_ntsd *)attrval;
> +               int dacloffset =3D le32toh(pfntsd->dacloffset);
> +               struct cifs_ctrl_acl *daclinfo =3D
> +                               (struct cifs_ctrl_acl *)(attrval + daclof=
fset);
> +               int numaces =3D le16toh(daclinfo->num_aces);
> +               int acessize =3D le32toh(daclinfo->size);
> +               size_t faceoffset, naceoffset;
> +               char *faceptr, *naceptr;
>
> -       facesptr =3D build_fetched_aces((char *)daclptr, numfaces);
> -       if (!facesptr)
> -               goto setcifsacl_facenum_ret;
> +               /*
> +                * this allocates large enough buffer for max sid size an=
d the
> +                * dacl info from the fetched security descriptor
> +                */
> +               rc =3D alloc_sec_desc(pfntsd, &ntsdptr, numaces, &faceoff=
set);
> +               if (rc)
> +                       goto setcifsacl_numcaces_ret;
>
> -       bufsize =3D 0;
> -       rc =3D setacl_action((struct cifs_ntsd *)attrval, &ntsdptr, &bufs=
ize,
> -               facesptr, numfaces, cacesptr, numcaces, maction);
> -       if (rc)
> -               goto setcifsacl_action_ret;
> +               /*
> +                * copy the control structures from the fetched descripto=
r, the
> +                * sid specified by the user, and adjust the offsets/move=
 dacl
> +                * control structure if needed
> +                */
> +               bufsize =3D copy_sec_desc_with_sid(pfntsd, ntsdptr, &sid,
> +                               maction);
> +
> +               /* copy aces verbatim as they have not changed */
> +               faceptr =3D attrval + faceoffset;
> +               naceoffset =3D le32toh(ntsdptr->dacloffset) +
> +                               sizeof(struct cifs_ctrl_acl);
> +               naceptr =3D (char *)ntsdptr + naceoffset;
> +               memcpy(naceptr, faceptr, acessize);
> +       } else {
> +               bufsize =3D 0;
> +
> +               numfaces =3D get_numfaces((struct cifs_ntsd *)attrval, at=
trlen,
> +                               &daclptr);
> +               if (!numfaces && maction !=3D ActAdd) {
> +                       /* if we are not adding aces */
> +                       printf("%s: Empty DACL\n", __func__);
> +                       goto setcifsacl_facenum_ret;
> +               }
> +
> +               facesptr =3D build_fetched_aces((char *)daclptr, numfaces=
);
> +               if (!facesptr)
> +                       goto setcifsacl_facenum_ret;
>
> -       attrlen =3D setxattr(filename, ATTRNAME, ntsdptr, bufsize, 0);
> +               rc =3D setacl_action((struct cifs_ntsd *)attrval, &ntsdpt=
r,
> +                               &bufsize, facesptr, numfaces, cacesptr,
> +                               numcaces, maction);
> +               if (rc)
> +                       goto setcifsacl_action_ret;
> +       }
> +
> +       attrlen =3D setxattr(filename, attrname, ntsdptr, bufsize, 0);
>         if (attrlen =3D=3D -1) {
>                 printf("%s: setxattr error: %s\n", __func__, strerror(err=
no));
> -               goto setcifsacl_facenum_ret;
> +               goto setcifsacl_action_ret;
>         }
>
>         if (plugin_loaded)
> @@ -951,25 +1110,33 @@ cifsacl:
>         return 0;
>
>  setcifsacl_action_ret:
> -       free(ntsdptr);
> +       if (ntsdptr)
> +               free(ntsdptr);
>
>  setcifsacl_facenum_ret:
> -       for (i =3D 0; i < numfaces; ++i)
> -               free(facesptr[i]);
> -       free(facesptr);
> +       if (facesptr) {
> +               for (i =3D 0; i < numfaces; ++i)
> +                       free(facesptr[i]);
> +               free(facesptr);
> +       }
>
>  setcifsacl_getx_ret:
> -       free(attrval);
> +       if (attrval)
> +               free(attrval);
>
>  setcifsacl_cmdlineverify_ret:
> -       for (i =3D 0; i < numcaces; ++i)
> -               free(cacesptr[i]);
> -       free(cacesptr);
> +       if (cacesptr) {
> +               for (i =3D 0; i < numcaces; ++i)
> +                       free(cacesptr[i]);
> +               free(cacesptr);
> +       }
>
>  setcifsacl_cmdlineparse_ret:
> -       free(arrptr);
> +       if (arrptr)
> +               free(arrptr);
>
>  setcifsacl_numcaces_ret:
> -       exit_plugin(plugin_handle);
> +       if (plugin_loaded)
> +               exit_plugin(plugin_handle);
>         return -1;
>  }
> diff --git a/setcifsacl.rst.in b/setcifsacl.rst.in
> index de9c758..985af7c 100644
> --- a/setcifsacl.rst.in
> +++ b/setcifsacl.rst.in
> @@ -2,16 +2,16 @@
>  setcifsacl
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> -------------------------------------------------------------------------=
------------------------
> -Userspace helper to alter an ACL in a security descriptor for Common Int=
ernet File System (CIFS)
> -------------------------------------------------------------------------=
------------------------
> +------------------------------------------------------------------------=
-------------------------------------------
> +Userspace helper to alter an ACL or owner/group SID in a security descri=
ptor for Common Internet File System (CIFS)
> +------------------------------------------------------------------------=
-------------------------------------------
>  :Manual section: 1
>
>  ********
>  SYNOPSIS
>  ********
>
> -  setcifsacl [-v|-a|-D|-M|-S] "{one or more ACEs}" {file system object}
> +  setcifsacl [-v|-a|-D|-M|-S|-o|-g] "{one or more ACEs or a SID}" {file =
system object}
>
>  ***********
>  DESCRIPTION
> @@ -20,7 +20,7 @@ DESCRIPTION
>  This tool is part of the cifs-utils suite.
>
>  ``setcifsacl`` is a userspace helper program for the Linux CIFS client
> -file system. It is intended to alter an ACL of a security descriptor
> +file system. It is intended to alter an ACL or set owner/group SID of a =
security descriptor
>  for a file system object. Whether a security descriptor to be set is
>  applied or not is determined by the CIFS/SMB server.
>
> @@ -55,6 +55,13 @@ OPTIONS
>    Set an ACL of security descriptor with the list of ACEs Existing ACL
>    is replaced entirely with the specified ACEs.
>
> +-o
> +  Set owner SID to one specified as a command line argument.
> +
> +-g
> +  Set group SID to one specified as a command line argument.
> +
> +  The owner/group SID can be specified as a name or a raw SID value.
>    Every ACE entry starts with "ACL:" One or more ACEs are specified
>    within double quotes.  Multiple ACEs are separated by a comma.
>
> @@ -93,6 +100,16 @@ Set an ACL
>
>    setcifsacl -S "ACL:CIFSTESTDOM\Administrator:0x0/0x0/FULL,ACL:CIFSTEST=
DOM\user2:0x0/0x0/FULL" <file_name>
>
> +Set owner SID
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +  setcifsacl -o "S-1-5-21-3338130290-3403600371-1423429424-2102" <file_n=
ame>
> +
> +Set group SID
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +  setcifsacl -g "Administrators@BUILTIN" <file_name>
> +
>  *****
>  NOTES
>  *****
> --
> 2.14.5
>


--
Best regards,
Pavel Shilovsky
