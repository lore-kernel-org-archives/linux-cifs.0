Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3A07C433EF
	for <linux-cifs@archiver.kernel.org>; Sat,  4 Jun 2022 06:23:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348487AbiFDGXp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 4 Jun 2022 02:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232531AbiFDGXo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 4 Jun 2022 02:23:44 -0400
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B7D317583
        for <linux-cifs@vger.kernel.org>; Fri,  3 Jun 2022 23:23:43 -0700 (PDT)
Received: by mail-vs1-xe2c.google.com with SMTP id c62so9208935vsc.10
        for <linux-cifs@vger.kernel.org>; Fri, 03 Jun 2022 23:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YaX3apoQYdPhJahf5/XneiGm5k1kHA+v/7jqB8QQGLo=;
        b=HEAkWUrkBwHVmq3K62mTlj5U4kEflSp074f0w7wTQ7wOcotmnuIZCFNxgx8VF1s6hl
         u36IFmaJ4tnb/by5oKxoaALn/9iYjt8MhwFtDcUT2hi5fBhSnDCVkGA1H++2inceMS1A
         1+tPOBk+BoYa4IsDbjNMhX9k6sJkYJGqlqxPoJ1/S+SD3hSCXAINACXu1WDBTG4zisi1
         0WnIquEB0meaSdqfvxZAHnOwBAR5MQ0ARvqjgyQuOWbjhqQkHQbOPO1bHVxV2bZZdzOS
         ApUFW0XZuEFNFSwptWfYyNmlxghhaqBhH9qHtQqZGNViMtpMREgxR3cub3kK7q+txuIg
         vzqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YaX3apoQYdPhJahf5/XneiGm5k1kHA+v/7jqB8QQGLo=;
        b=seHowsIdViHipwaj6CkiiHtyfiJSKUg+mdM1GBIHV6aRn1MMqk9EivoYSQ5x+CAvYf
         tyq1ugvZuJk8E0cw/zJ+J7S2PopqbQLIu9fEKQdtLLKWXSdPmWnQ37jXfM4rw7pS8xv0
         pap9d+KBt2F0dRcMU92FunRRfVLoLzA/femJi3xGj7o9W5k/I2FOyRlkp9oURczfoTbR
         fC1xLtxqpUwtvd59Foy2wE1LLOigrNpzIRdnNhQxKShiXhIE53mjJqT7Du9LcD/MM296
         da7shCxj5AiryB289rcUkkxzWFz9OFG0VhIAoSp5D0QHDMO/7VE1rKGUkBOq06Y9IJbU
         iFKw==
X-Gm-Message-State: AOAM530x6yUCAOMh+PfJCYK+ZWPSUGmhjg1cDV4kUb9Kr3EGzkbShnk5
        1WWhocHIXVhoyPBUdpeB5dQsxngd3qKY4jai/kOgJBQX
X-Google-Smtp-Source: ABdhPJwZfN8vF0KswK9iN08GMZTJHZZ4lUSrylInmODU8TZB/9WHDZkmjsnEK+2VWOZAyJqYxPuozfrfsgeiJYw/lBA=
X-Received: by 2002:a67:1787:0:b0:337:d8cd:35b2 with SMTP id
 129-20020a671787000000b00337d8cd35b2mr5909596vsx.29.1654323822115; Fri, 03
 Jun 2022 23:23:42 -0700 (PDT)
MIME-Version: 1.0
References: <202206041223.Kx81JSQt-lkp@intel.com> <DM6PR21MB1466F4E4127EADC233ACC794E4A09@DM6PR21MB1466.namprd21.prod.outlook.com>
In-Reply-To: <DM6PR21MB1466F4E4127EADC233ACC794E4A09@DM6PR21MB1466.namprd21.prod.outlook.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 4 Jun 2022 01:23:30 -0500
Message-ID: <CAH2r5mvmtEhfNXRjVsoG7g5RaS8Xu1H8tgt1NoU6Nr+zx122Ew@mail.gmail.com>
Subject: Re: [EXTERNAL] [cifs:for-next 8/8] fs/cifs/dfs_cache.c:1294:2:
 warning: variable 'ppath' is used uninitialized whenever 'if' condition is false
To:     Steven French <Steven.French@microsoft.com>,
        Paulo Alcantara <pc@cjr.nz>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000c2d28305e09947f4"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000c2d28305e09947f4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

patch attached to set ppath to null by default


On Sat, Jun 4, 2022 at 12:22 AM Steven French
<Steven.French@microsoft.com> wrote:
>
>
>
> Get Outlook for Android
> ________________________________
> From: kernel test robot <lkp@intel.com>
> Sent: Friday, June 3, 2022 10:00:31 PM
> To: pc <pc@cjr.nz>
> Cc: llvm@lists.linux.dev <llvm@lists.linux.dev>; kbuild-all@lists.01.org =
<kbuild-all@lists.01.org>; linux-cifs@vger.kernel.org <linux-cifs@vger.kern=
el.org>; samba-technical@lists.samba.org <samba-technical@lists.samba.org>;=
 Steven French <Steven.French@microsoft.com>
> Subject: [EXTERNAL] [cifs:for-next 8/8] fs/cifs/dfs_cache.c:1294:2: warni=
ng: variable 'ppath' is used uninitialized whenever 'if' condition is false
>
> tree:   git://git.samba.org/sfrench/cifs-2.6.git for-next
> head:   ef605e86821253d16d47a02ce1f766a461614fef
> commit: ef605e86821253d16d47a02ce1f766a461614fef [8/8] cifs: skip trailin=
g separators of prefix paths
> config: arm-randconfig-c002-20220603 (https://nam06.safelinks.protection.=
outlook.com/?url=3Dhttps%3A%2F%2Fdownload.01.org%2F0day-ci%2Farchive%2F2022=
0604%2F202206041223.Kx81JSQt-lkp%40intel.com%2Fconfig&amp;data=3D05%7C01%7C=
Steven.French%40microsoft.com%7C8fd0f93076304ca4db7408da45e74210%7C72f988bf=
86f141af91ab2d7cd011db47%7C1%7C0%7C637899156811777573%7CUnknown%7CTWFpbGZsb=
3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C300=
0%7C%7C%7C&amp;sdata=3DI%2FEylneaMr3LmxdLWgGMfgoePbuxH5tathKlIaR5dJU%3D&amp=
;reserved=3D0)
> compiler: clang version 15.0.0 (https://nam06.safelinks.protection.outloo=
k.com/?url=3Dhttps%3A%2F%2Fgithub.com%2Fllvm%2Fllvm-project&amp;data=3D05%7=
C01%7CSteven.French%40microsoft.com%7C8fd0f93076304ca4db7408da45e74210%7C72=
f988bf86f141af91ab2d7cd011db47%7C1%7C0%7C637899156811777573%7CUnknown%7CTWF=
pbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D=
%7C3000%7C%7C%7C&amp;sdata=3DIIT72ydb3VXEpUd8pYus96zzwjWnvHcHJgP4uFbLI2U%3D=
&amp;reserved=3D0 b364c76683f8ef241025a9556300778c07b590c2)
> reproduce (this is a W=3D1 build):
>         wget https://nam06.safelinks.protection.outlook.com/?url=3Dhttps%=
3A%2F%2Fraw.githubusercontent.com%2Fintel%2Flkp-tests%2Fmaster%2Fsbin%2Fmak=
e.cross&amp;data=3D05%7C01%7CSteven.French%40microsoft.com%7C8fd0f93076304c=
a4db7408da45e74210%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0%7C63789915681=
1777573%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI=
6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=3DrWO79li71JswarF6XxfENQw=
mBdCbcQ4sG5m%2FhQCcl3M%3D&amp;reserved=3D0 -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # install arm cross compiling tool for clang build
>         # apt-get install binutils-arm-linux-gnueabi
>         git remote add cifs git://git.samba.org/sfrench/cifs-2.6.git
>         git fetch --no-tags cifs for-next
>         git checkout ef605e86821253d16d47a02ce1f766a461614fef
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dclang make.cross W=
=3D1 O=3Dbuild_dir ARCH=3Darm SHELL=3D/bin/bash fs/cifs/
>
> If you fix the issue, kindly add following tag where applicable
> Reported-by: kernel test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
> >> fs/cifs/dfs_cache.c:1294:2: warning: variable 'ppath' is used uninitia=
lized whenever 'if' condition is false [-Wsometimes-uninitialized]
>            if (target_pplen || dfsref_pplen) {
>            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    include/linux/compiler.h:56:28: note: expanded from macro 'if'
>    #define if(cond, ...) if ( __trace_if_var( !!(cond , ## __VA_ARGS__) )=
 )
>                               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    include/linux/compiler.h:58:30: note: expanded from macro '__trace_if_=
var'
>    #define __trace_if_var(cond) (__builtin_constant_p(cond) ? (cond) : __=
trace_if_value(cond))
>                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~~~~~~~~~~~~~
>    fs/cifs/dfs_cache.c:1307:12: note: uninitialized use occurs here
>            *prefix =3D ppath;
>                      ^~~~~
>    fs/cifs/dfs_cache.c:1294:2: note: remove the 'if' if its condition is =
always true
>            if (target_pplen || dfsref_pplen) {
>            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    include/linux/compiler.h:56:23: note: expanded from macro 'if'
>    #define if(cond, ...) if ( __trace_if_var( !!(cond , ## __VA_ARGS__) )=
 )
>                          ^
>    fs/cifs/dfs_cache.c:1270:28: note: initialize the variable 'ppath' to =
silence this warning
>            char *target_share, *ppath;
>                                      ^
>                                       =3D NULL
>    1 warning generated.
>
>
> vim +1294 fs/cifs/dfs_cache.c
>
>   1255
>   1256  /**
>   1257   * dfs_cache_get_tgt_share - parse a DFS target
>   1258   *
>   1259   * @path: DFS full path
>   1260   * @it: DFS target iterator.
>   1261   * @share: tree name.
>   1262   * @prefix: prefix path.
>   1263   *
>   1264   * Return zero if target was parsed correctly, otherwise non-zero=
.
>   1265   */
>   1266  int dfs_cache_get_tgt_share(char *path, const struct dfs_cache_tg=
t_iterator *it, char **share,
>   1267                              char **prefix)
>   1268  {
>   1269          char sep;
>   1270          char *target_share, *ppath;
>   1271          const char *target_ppath, *dfsref_ppath;
>   1272          size_t target_pplen, dfsref_pplen;
>   1273          size_t len, c;
>   1274
>   1275          if (!it || !path || !share || !prefix || strlen(path) < i=
t->it_path_consumed)
>   1276                  return -EINVAL;
>   1277
>   1278          sep =3D it->it_name[0];
>   1279          if (sep !=3D '\\' && sep !=3D '/')
>   1280                  return -EINVAL;
>   1281
>   1282          target_ppath =3D parse_target_share(it->it_name, &target_=
share);
>   1283          if (IS_ERR(target_ppath))
>   1284                  return PTR_ERR(target_ppath);
>   1285
>   1286          /* point to prefix in DFS referral path */
>   1287          dfsref_ppath =3D path + it->it_path_consumed;
>   1288          dfsref_ppath +=3D strspn(dfsref_ppath, "/\\");
>   1289
>   1290          target_pplen =3D strlen(target_ppath);
>   1291          dfsref_pplen =3D strlen(dfsref_ppath);
>   1292
>   1293          /* merge prefix paths from DFS referral path and target n=
ode */
> > 1294          if (target_pplen || dfsref_pplen) {
>   1295                  len =3D target_pplen + dfsref_pplen + 2;
>   1296                  ppath =3D kzalloc(len, GFP_KERNEL);
>   1297                  if (!ppath) {
>   1298                          kfree(target_share);
>   1299                          return -ENOMEM;
>   1300                  }
>   1301                  c =3D strscpy(ppath, target_ppath, len);
>   1302                  if (c && dfsref_pplen)
>   1303                          ppath[c] =3D sep;
>   1304                  strlcat(ppath, dfsref_ppath, len);
>   1305          }
>   1306          *share =3D target_share;
>   1307          *prefix =3D ppath;
>   1308          return 0;
>   1309  }
>   1310
>
> --
> 0-DAY CI Kernel Test Service
> https://nam06.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2F01.or=
g%2Flkp&amp;data=3D05%7C01%7CSteven.French%40microsoft.com%7C8fd0f93076304c=
a4db7408da45e74210%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0%7C63789915681=
1777573%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI=
6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=3DDA%2FZslJz3uARiZHC0HxgS=
P3ccOYqv%2B%2FUh68fCZm3Fgk%3D&amp;reserved=3D0



--=20
Thanks,

Steve

--000000000000c2d28305e09947f4
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-fix-uninitialized-pointer-in-error-case-in-dfs_.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-fix-uninitialized-pointer-in-error-case-in-dfs_.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l3zhofc00>
X-Attachment-Id: f_l3zhofc00

RnJvbSA0NmNlNjk2NjIxNjllMTBmZjYyMWFlYTBlMzY4ZDMwYWJiZTZhYzk5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFNhdCwgNCBKdW4gMjAyMiAwMToxODozNyAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIGNp
ZnM6IGZpeCB1bmluaXRpYWxpemVkIHBvaW50ZXIgaW4gZXJyb3IgY2FzZSBpbgogZGZzX2NhY2hl
X2dldF90Z3Rfc2hhcmUKClNldCBkZWZhdWx0IHZhbHVlIG9mIHBwYXRoIHRvIG51bGwuCgpSZXBv
cnRlZC1ieToga2VybmVsIHRlc3Qgcm9ib3QgPGxrcEBpbnRlbC5jb20+ClNpZ25lZC1vZmYtYnk6
IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL2Rmc19j
YWNoZS5jIHwgMyArKy0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDEgZGVsZXRp
b24oLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL2Rmc19jYWNoZS5jIGIvZnMvY2lmcy9kZnNfY2Fj
aGUuYwppbmRleCA3Yjk3OGExMjYyNjguLjM0YThmM2JhZWQ1ZSAxMDA2NDQKLS0tIGEvZnMvY2lm
cy9kZnNfY2FjaGUuYworKysgYi9mcy9jaWZzL2Rmc19jYWNoZS5jCkBAIC0xMjY3LDcgKzEyNjcs
OCBAQCBpbnQgZGZzX2NhY2hlX2dldF90Z3Rfc2hhcmUoY2hhciAqcGF0aCwgY29uc3Qgc3RydWN0
IGRmc19jYWNoZV90Z3RfaXRlcmF0b3IgKml0LAogCQkJICAgIGNoYXIgKipwcmVmaXgpCiB7CiAJ
Y2hhciBzZXA7Ci0JY2hhciAqdGFyZ2V0X3NoYXJlLCAqcHBhdGg7CisJY2hhciAqdGFyZ2V0X3No
YXJlOworCWNoYXIgKnBwYXRoID0gTlVMTDsKIAljb25zdCBjaGFyICp0YXJnZXRfcHBhdGgsICpk
ZnNyZWZfcHBhdGg7CiAJc2l6ZV90IHRhcmdldF9wcGxlbiwgZGZzcmVmX3BwbGVuOwogCXNpemVf
dCBsZW4sIGM7Ci0tIAoyLjM0LjEKCg==
--000000000000c2d28305e09947f4--
