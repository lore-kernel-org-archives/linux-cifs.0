Return-Path: <SRS0=OUxG=UX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D685EC43613
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Jun 2019 06:23:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8B4B21530
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Jun 2019 06:23:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BgRZ9cjE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbfFXGXT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Jun 2019 02:23:19 -0400
Received: from mail-pg1-f172.google.com ([209.85.215.172]:42757 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726351AbfFXGXT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 24 Jun 2019 02:23:19 -0400
Received: by mail-pg1-f172.google.com with SMTP id k13so362957pgq.9
        for <linux-cifs@vger.kernel.org>; Sun, 23 Jun 2019 23:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=KGt9jkDXXYs1IygaGthhf8AqbLIU0NUmbMUWqVvw+N8=;
        b=BgRZ9cjEmIbBYoCjA8Pf6aR/FTGMVm0BoSIJPzV93HuA6AffyPsfmThauo0unshaWy
         S0mol97uCjVOHmgKzGMf4kL5xVhlXDpizZIpXzoHV8k7YCdYLqrT99m9UhSzWOHv4zUd
         FhSRGQibZH4iDMP8/2ch3UmaZugLWN9kHxQVDk3tdOevcBdNEufT5y2Pu2Bq+zTcjTvy
         2Oe54XUHTPWJKNjGrfzo2tB72Ht2x1SebnRuODMDgHzsoFhhHQt8JFIaZodcPlfHxZzl
         5YKnW7bbAxvwYHYKI4EjWiR7X5MxXW+xepYRClnQDna/GusbE1Mvjgu7k+9w7rDaagv8
         GPuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=KGt9jkDXXYs1IygaGthhf8AqbLIU0NUmbMUWqVvw+N8=;
        b=S45PyO7zRd1N88uQrS4H8JcT5Dhr2UkybU/wGtBc2ndlbp6iWb6GP2xUo9PQFR+o57
         KAaFqgnkVwlfi0rxwKtavZ1LupAtEs5ICvimljn66czrn515NMgWFdnTjPOfmZF8cDIN
         PZvQtz5My/0B6rQruu/hUpVV7ExQiQrg2nGlsCjK2Mh3c4c43+NI5MwT4CJHLo1L0eRE
         FT9OJicc6auUaKX3yJCsm3dGvL419y/HlJ7nxXMKtHYr1l0XVxh1X61VQYUkKwBAzkbO
         BxgFo5iJSZBy4kojQB0FOSHO0me8iFdWCVfLIEs1x+tiCb9IEPwyphjOO5YKigandyrh
         2Rjw==
X-Gm-Message-State: APjAAAXQQc0A+KP7bI7E9PAGW7N1wBEu2I41NkTTxH+n3Iq7GZU4aaQE
        owTJasNv6vuzajvELasxgQE2AnhO857JvKil6rA7Ew==
X-Google-Smtp-Source: APXvYqwiNx4NrjtH4YC1DgueFln42s5XnfIHSiUvXxieXrcKJD54VugJiOkOd9pv93nlUZR1x6frzMeZiqsh3qHXvtk=
X-Received: by 2002:a17:90a:fa07:: with SMTP id cm7mr22141888pjb.138.1561357398221;
 Sun, 23 Jun 2019 23:23:18 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvoNkD-oMwzYL6nYu1rWBfU3i=8iWZMLHASDoABMLJmJg@mail.gmail.com>
In-Reply-To: <CAH2r5mvoNkD-oMwzYL6nYu1rWBfU3i=8iWZMLHASDoABMLJmJg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 24 Jun 2019 01:23:07 -0500
Message-ID: <CAH2r5mv7vD3bFHwZJfmj3U1cjUcwwUtLy4eFTc2h6O3HgtOUww@mail.gmail.com>
Subject: Re: Matching superblocks on second mount of same share
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000016ca1e058c0bd953"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000016ca1e058c0bd953
Content-Type: text/plain; charset="UTF-8"

Attached is a patch which addresses a few of them which seem more
important (MOUNT_POSIXACL is SMB1 only so I would prefer not to touch
that one)

On Mon, Jun 24, 2019 at 1:08 AM Steve French <smfrench@gmail.com> wrote:
>
> I noticed that we don't have these six flags defined in cifsglob.h in
> the CIFS_MOUNT_MASK used to see if superblocks match when doing a
> second mount of the same share
>
> #define CIFS_MOUNT_RWPIDFORWARD 0x80000
> #define CIFS_MOUNT_POSIXACL     0x100000
> #define CIFS_MOUNT_USE_PREFIX_PATH 0x1000000
> #define CIFS_MOUNT_UID_FROM_ACL 0x2000000
> #define CIFS_MOUNT_NO_HANDLE_CACHE 0x4000000
> #define CIFS_MOUNT_MAP_SFM_CHR  0x800000
>
> Any thoughts if any of thes really can be ignored in the check for
> superblock matches?
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve

--00000000000016ca1e058c0bd953
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-Fix-check-for-matching-with-existing-mount.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-Fix-check-for-matching-with-existing-mount.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jx9zvdcm0>
X-Attachment-Id: f_jx9zvdcm0

RnJvbSA2ZTk2YzQ1NzFiNDQxNjMzZjQ0MjEwOWNmYzEzZTJmOWMxMTAxMGEzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgMjQgSnVuIDIwMTkgMDE6MTk6NTIgLTA1MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBGaXggY2hlY2sgZm9yIG1hdGNoaW5nIHdpdGggZXhpc3RpbmcgbW91bnQKCklmIHdlIG1v
dW50IHRoZSBzYW1lIHNoYXJlIHR3aWNlLCB3ZSBjaGVjayB0aGUgZmxhZ3MgdG8gc2VlIGlmIHRo
ZQpzZWNvbmQgbW91bnQgbWF0Y2hlcyB0aGUgZWFybGllciBtb3VudCwgYnV0IHdlIGxlZnQgc29t
ZSBmbGFncyBvdXQuCgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jv
c29mdC5jb20+Ci0tLQogZnMvY2lmcy9jaWZzZ2xvYi5oIHwgMSArCiAxIGZpbGUgY2hhbmdlZCwg
MSBpbnNlcnRpb24oKykKCmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNnbG9iLmggYi9mcy9jaWZz
L2NpZnNnbG9iLmgKaW5kZXggNDc3N2IzYzRhOTJjLi44OGM5OGZhMTVmMzkgMTAwNjQ0Ci0tLSBh
L2ZzL2NpZnMvY2lmc2dsb2IuaAorKysgYi9mcy9jaWZzL2NpZnNnbG9iLmgKQEAgLTYxNyw2ICs2
MTcsNyBAQCBzdHJ1Y3Qgc21iX3ZvbCB7CiAJCQkgQ0lGU19NT1VOVF9GU0NBQ0hFIHwgQ0lGU19N
T1VOVF9NRl9TWU1MSU5LUyB8IFwKIAkJCSBDSUZTX01PVU5UX01VTFRJVVNFUiB8IENJRlNfTU9V
TlRfU1RSSUNUX0lPIHwgXAogCQkJIENJRlNfTU9VTlRfQ0lGU19CQUNLVVBVSUQgfCBDSUZTX01P
VU5UX0NJRlNfQkFDS1VQR0lEIHwgXAorCQkJIENJRlNfTU9VTlRfVUlEX0ZST01fQUNMIHwgQ0lG
U19NT1VOVF9OT19IQU5ETEVfQ0FDSEUgfCBcCiAJCQkgQ0lGU19NT1VOVF9OT19ERlMpCiAKIC8q
KgotLSAKMi4yMC4xCgo=
--00000000000016ca1e058c0bd953--
