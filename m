Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69A9CC54EE9
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Sep 2022 02:51:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiINCvH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 13 Sep 2022 22:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiINCvF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 13 Sep 2022 22:51:05 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1BA45F22F
        for <linux-cifs@vger.kernel.org>; Tue, 13 Sep 2022 19:51:03 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id q26so8975028vsr.7
        for <linux-cifs@vger.kernel.org>; Tue, 13 Sep 2022 19:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=H4HcDQyYzv81BC9BmIasoALXzuRaVd1nOWtIW+fha1w=;
        b=kzXvvm5Pk5CUkm1agrhRrVufTL1u6f+2A0NHLaZVNc90+8TI2KP+xeold6fnZSExYB
         qGd2gEouEK95MnArs0icvAzKsX2aXBwJyD7C3/dj0gK9dymh+n/V8gfY/vmedhSj1n06
         7gHhrLgnQLIDK3++8PMJa+c25O6d8hxUroW2QXXzpsXrgLZqUFXSxdJlefuPnVPgAa8P
         A4lQP6Ld5CO2uMlIKL6vm1i1a04YR71yvM6YBK8Ic8817MflaTjpfbXdbPsk06EnmJes
         6FnPOmKtbfVnElyLKXmGQAAC1VVuKYxyTb6ZrdBSyuWDZ+VSm+nOAX+zDVquB1r8kCaz
         MjGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=H4HcDQyYzv81BC9BmIasoALXzuRaVd1nOWtIW+fha1w=;
        b=qmJ9+C97mgRLIFN5U75ymTDH6vJqbzJ+e3MnsrcET+3SYk50GBkE2ScJ1iGWHdeaUX
         drt2F8AJVq2cTDgAbksLlZZCL+yKMkzec84pIfLpOwIVuYz5tXfj99nOHAE9bauSv4mB
         Wqm6sxITDJKfVzpDQr7QgYcx4t3i48DbWKC2dc7FTlW68SVtH9UoRfyJiwqMXXI73PgC
         /dwt5aZJXRJpdOLAd8nrvnpzfOn/TqCfcFNIyQoZsBgAvRvNC+XMe7rg5f9bJg3yMoPq
         tfXRe+ITrAHALnRHyPFx3Rf9XL8BoyLwipySIvFffYemwMCl9MV3mtLsxztFVw06eGNE
         rC2Q==
X-Gm-Message-State: ACgBeo2bFwsJYZAt/R9xUYntBjjQpaOd6lLTS2T/zRsTWzLU9u4WAOGJ
        Lk1qHhQ3x9dOr0iA6Ec7fXbVj6vowjR2XmFdrVE=
X-Google-Smtp-Source: AA6agR7TsUEmj7JdvanD2JbrSwuudpJHjBN/pwBDizhTc/kyYt4L1G6hO3ywLrhTnCH50Rldm4wq8YV6x5FWEdNLeHk=
X-Received: by 2002:a05:6102:3e82:b0:38a:ab1a:2702 with SMTP id
 m2-20020a0561023e8200b0038aab1a2702mr11040401vsv.29.1663123862655; Tue, 13
 Sep 2022 19:51:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220906013040.2467-1-ematsumiya@suse.de> <CA+5B0FNBJVFC6-SfVodctu0DkyyZ9DzJM8OJsDBbVb453Mvfsw@mail.gmail.com>
 <20220907204140.77ssfeib3zmwvqy2@cyberdelia>
In-Reply-To: <20220907204140.77ssfeib3zmwvqy2@cyberdelia>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 13 Sep 2022 21:50:51 -0500
Message-ID: <CAH2r5msyrbfM71WDpUggD7V_YTZhE50w7y4Umt=QjAG=Yfhz7g@mail.gmail.com>
Subject: Re: [PATCH] cifs: perf improvement - use faster macros ALIGN() and round_up()
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aurelien.aptel@gmail.com>,
        linux-cifs@vger.kernel.org, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Most of the changes look ok to me, although not much point in changing
the lines like:

     x =3D 2 /* sizeof(__u16) */ ....
to
     x =3D sizeof(__u16) ...

not sure that those  particular kinds of changes help enough with
readability (but they make backports harder) - and they have 0 impact
on performance.   So even if that type of change helps readability a
small amount, it could be split out from the things which could help
performance (and/or clearly improve readability).

The one area that looked confusing is this part.  Can you explain why
this part of the change?

@@ -2687,20 +2683,17 @@ int smb311_posix_mkdir(const unsigned int xid,
struct inode *inode,
                uni_path_len =3D (2 * UniStrnlen((wchar_t *)utf16_path,
PATH_MAX)) + 2;
                /* MUST set path len (NameLength) to 0 opening root of shar=
e */
                req->NameLength =3D cpu_to_le16(uni_path_len - 2);
-               if (uni_path_len % 8 !=3D 0) {
-                       copy_size =3D roundup(uni_path_len, 8);
-                       copy_path =3D kzalloc(copy_size, GFP_KERNEL);
-                       if (!copy_path) {
-                               rc =3D -ENOMEM;
-                               goto err_free_req;
-                       }
-                       memcpy((char *)copy_path, (const char *)utf16_path,
-                              uni_path_len);
-                       uni_path_len =3D copy_size;
-                       /* free before overwriting resource */
-                       kfree(utf16_path);
-                       utf16_path =3D copy_path;
+               copy_size =3D round_up(uni_path_len, 8);
+               copy_path =3D kzalloc(copy_size, GFP_KERNEL);
+               if (!copy_path) {
+                       rc =3D -ENOMEM;
+                       goto err_free_req;
                }
+               memcpy((char *)copy_path, (const char *)utf16_path,
uni_path_len);
+               uni_path_len =3D copy_size;
+               /* free before overwriting resource */
+               kfree(utf16_path);
+               utf16_path =3D copy_path;
        }


On Wed, Sep 7, 2022 at 3:41 PM Enzo Matsumiya <ematsumiya@suse.de> wrote:
>
> On 09/07, Aur=C3=A9lien Aptel wrote:
> >Hi,
> >
> >Changes are good from a readability stand point but like the others
> >I'm very skeptical about the perf improvement claims.
>
> Just to be clear, as I re-read the commit message and realize I might hav=
e
> sounded a tad sensationalist; the "~50% improvement" was from the measure=
 of
> the average latency for a single copy operation. As I replied to Tom Talp=
ey in
> https://lore.kernel.org/linux-cifs/20220906160508.x4ahjzo3tr34w6k5@cyberd=
elia/
> the actual perceptible gain was only 0.02 to 0.05 seconds on my tests.
>
> Pardon me for any confusion.
>
>
> Enzo
>
> >On Tue, Sep 6, 2022 at 3:34 AM Enzo Matsumiya <ematsumiya@suse.de> wrote=
:
> >> But also replace (DIV_ROUND_UP(len, 8) * 8) with ALIGN(len, 8), which,
> >> if not optimized by the compiler, has the overhead of a multiplication
> >> and a division. Do the same for roundup() by replacing it by round_up(=
)
> >> (division-less version, but requires the multiple to be a power of 2,
> >> which is always the case for us).
> >
> >Many of these compile to the same division-less instructions
> >especially if any of the values are known at compile time.
> >
> >> @@ -2305,7 +2305,7 @@ int CIFSSMBRenameOpenFile(const unsigned int xid=
, struct cifs_tcon *pTcon,
> >
> >smb1 and computed at compile time
> >
> >> @@ -3350,8 +3350,7 @@ validate_ntransact(char *buf, char **ppparm, cha=
r **ppdata,
> >
> >smb1
> >
> >> @@ -2833,9 +2833,12 @@ ip_rfc1001_connect(struct TCP_Server_Info *serv=
er)
> >> @@ -2871,8 +2874,12 @@ ip_rfc1001_connect(struct TCP_Server_Info *serv=
er)
> >
> >connect time
> >
> >> @@ -1318,7 +1313,7 @@ sess_auth_ntlmv2(struct sess_data *sess_data)
> >> @@ -1442,8 +1437,7 @@ sess_auth_kerberos(struct sess_data *sess_data)
> >> @@ -1494,7 +1488,7 @@ sess_auth_kerberos(struct sess_data *sess_data)
> >> @@ -1546,7 +1540,7 @@ _sess_auth_rawntlmssp_assemble_req(struct sess_d=
ata *sess_data)
> >> @@ -1747,7 +1741,7 @@ sess_auth_rawntlmssp_authenticate(struct sess_da=
ta *sess_data)
> >
> >connect time
> >
> >> @@ -207,7 +207,7 @@ smb2_compound_op(const unsigned int xid, struct ci=
fs_tcon *tcon,
> >> -               size[0] =3D 1; /* sizeof __u8 See MS-FSCC section 2.4.=
11 */
> >> +               size[0] =3D sizeof(u8); /* See MS-FSCC section 2.4.11 =
*/
> >> -               size[0] =3D 8; /* sizeof __le64 */
> >> +               size[0] =3D sizeof(__le64);
> >
> >Hot path but no functional change
> >
> >> @@ -248,7 +248,7 @@ smb2_check_message(char *buf, unsigned int len, st=
ruct TCP_Server_Info *server)
> >>                  * Some windows servers (win2016) will pad also the fi=
nal
> >>                  * PDU in a compound to 8 bytes.
> >>                  */
> >> -               if (((calc_len + 7) & ~7) =3D=3D len)
> >> +               if (ALIGN(calc_len, 8) =3D=3D len)
> >
> >Hot path but should compile to the same thing
> >
> >> @@ -466,15 +466,14 @@ build_signing_ctxt(struct smb2_signing_capabilit=
ies *pneg_ctxt)
> >> @@ -511,8 +510,7 @@ build_netname_ctxt(struct smb2_netname_neg_context=
 *pneg_ctxt, char *hostname)
> >> @@ -557,18 +555,18 @@ assemble_neg_contexts(struct smb2_negotiate_req =
*req,
> >> @@ -595,9 +593,7 @@ assemble_neg_contexts(struct smb2_negotiate_req *r=
eq,
> >> @@ -780,7 +776,7 @@ static int smb311_decode_neg_context(struct smb2_n=
egotiate_rsp *rsp,
> >
> >connect time
> >
> >> @@ -2413,7 +2409,7 @@ create_sd_buf(umode_t mode, bool set_owner, unsi=
gned int *len)
> >> @@ -2487,7 +2483,7 @@ create_sd_buf(umode_t mode, bool set_owner, unsi=
gned int *len)
> >
> >only relevant if mounted with some acl flags
> >
> >> @@ -2581,7 +2577,7 @@ alloc_path_with_tree_prefix(__le16 **out_path, i=
nt *out_size, int *out_len,
> >> -       *out_size =3D roundup(*out_len * sizeof(__le16), 8);
> >> +       *out_size =3D round_up(*out_len * sizeof(__le16), 8);
> >
> >Hot path but from my experiments, round_up() compiles to an *extra*
> >instruction. See below.
> >
> >> @@ -2687,20 +2683,17 @@ int smb311_posix_mkdir(const unsigned int xid,=
 struct inode *inode,
> >
> >Only relevant on posix mounts.
> >
> >> @@ -2826,9 +2819,7 @@ SMB2_open_init(struct cifs_tcon *tcon, struct TC=
P_Server_Info *server,
> >> -               copy_size =3D uni_path_len;
> >> -               if (copy_size % 8 !=3D 0)
> >> -                       copy_size =3D roundup(copy_size, 8);
> >> +               copy_size =3D round_up(uni_path_len, 8);
> >> @@ -4090,7 +4081,7 @@ smb2_new_read_req(void **buf, unsigned int *tota=
l_len,
> >> -                       *total_len =3D DIV_ROUND_UP(*total_len, 8) * 8=
;
> >> +                       *total_len =3D ALIGN(*total_len, 8);
> >
> >These 2 are also hot paths, but skeptical about the optimizations.
> >
> >I've looked at those macros in Compiler Explorer and sure enough they
> >compile to the same thing on x86_64.
> >Even worse, the optimized versions compile with extra instructions for s=
ome:
> >
> >https://godbolt.org/z/z1xhhW9sj
> >
> >size_t mod2(size_t num) {
> >    return num%2;
> >}
> >
> >size_t is_aligned2(size_t num) {
> >    return IS_ALIGNED(num, 2);
> >}
> >
> >mod2:
> >        mov     rax, rdi
> >        and     eax, 1
> >        ret
> >
> >is_aligned2:
> >        mov     rax, rdi
> >        not     rax  <=3D=3D=3D extra
> >        and     eax, 1
> >        ret
> >--------------------------
> >
> >size_t align8(size_t num) {
> >    return ALIGN(num, 8);
> >}
> >
> >size_t align_andshift8(size_t num) {
> >    return ((num + 7) & ~7);
> >}
> >
> >
> >align8:
> >        lea     rax, [rdi+7]
> >        and     rax, -8
> >        ret
> >align_andshift8:
> >        lea     rax, [rdi+7]
> >        and     rax, -8
> >        ret
> >
> >same code
> >--------------------------
> >
> >size_t dru8(size_t num) {
> >    return DIV_ROUND_UP(num, 8)*8;
> >}
> >
> >size_t rnup8_a(size_t num) {
> >    return round_up(num, 8);
> >}
> >
> >size_t rnup8_b(size_t num) {
> >    return roundup(num, 8);
> >}
> >
> >dru8:
> >        lea     rax, [rdi+7]
> >        and     rax, -8
> >        ret
> >rnup8_a:
> >        lea     rax, [rdi-1]
> >        or      rax, 7 <=3D=3D=3D=3D extra
> >        add     rax, 1
> >        ret
> >rnup8_b:
> >        lea     rax, [rdi+7]
> >        and     rax, -8
> >        ret
> >
> >round_up has an extra instruction
> >--------------------------
> >
> >I suspect the improvements are more likely to be related to caches,
> >system load, server load, ...
> >You can try to use perf to make a flamegraph and compare.
> >
> >Cheers,



--=20
Thanks,

Steve
