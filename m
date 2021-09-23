Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DE07C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 21:09:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 629E360F70
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 21:09:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243216AbhIWVLI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Sep 2021 17:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243174AbhIWVLI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Sep 2021 17:11:08 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F09C061574
        for <linux-cifs@vger.kernel.org>; Thu, 23 Sep 2021 14:09:35 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id t10so31451372lfd.8
        for <linux-cifs@vger.kernel.org>; Thu, 23 Sep 2021 14:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=owmN6pGylDGGV4lQE8s8tRH1s6hyKntyBfJqvAs/C18=;
        b=TuTUOS39KLbDEIp52dzTlRQtPaKujxxFydpuffOTXBHZV++ybcfOEVv3I5fWd+tBfL
         uReHY4Gx6aTaqc4VCXhrLFb00/1wteIql3bzaY9FAemSEWycbtNog2EKWXUEgVQuUwwl
         BIT0ssU3jntLbH1yLSdUsjVofKqoPYJFPpsbhFPxcsSwGtoFaZB+fOwWszZ4MOFvBfah
         YmZ4prr6fCNbWDDV/Lu8c6rbGRmKY3GdO66Y9GD1gkTvPu4v4TX8sjd3+nHJxQxCbM6o
         HshV9ESMU17S9xVkC49HENczYNvJ3yY2ygjen1JTZ7y4s4wHLKxWJYeYnjO+A6SUL5ye
         nJaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=owmN6pGylDGGV4lQE8s8tRH1s6hyKntyBfJqvAs/C18=;
        b=lR8iuzJzivYeVrorgh+fypsL08jFaM3zblKvUy56C7UcIdUKEhZaAFhVrXkr7/fDao
         M7fK6Fh+CNrbG63tDQauUTmOiCm2aTS72Vc2JWFtDWMlryf3w+4tr4QRWovyI+Gadyy0
         elfUt67M7FM91qWYjMJZ/jXWLpJqz1DaAdfyG05HPnZKEb8Nr9DhRitXN8pr9UWQ1M1O
         Pagx7JMCdvXICXPUy9LEGzxyMvOFnNeaBrdqUF8TzZ36azkls3AFxCaFCiHgY7lhIXXQ
         kXJ44gl9rsl3XEXveVaqMz4B5oDdhYLU4uIcSm+a6Cu26VhSyeKhXgSZSXrJAWU0Um8J
         ZM5w==
X-Gm-Message-State: AOAM532NowLMNfWeGWK85ZlXmBfrjqjyt76SnOAK+CAQIpkjgJ1U8s7/
        LphuI8+t2WCv5uXFrg/Rq4ECZv3VJcRpQny5BWc=
X-Google-Smtp-Source: ABdhPJwjo6uTwaiQy3gzELscyFIoMBG8JevCgpNyNpm9rjxNJpMtd7ECYNYe7h+k/k2wa8Yf+A4+qS0tlWnNHRBiRLc=
X-Received: by 2002:ac2:44b6:: with SMTP id c22mr6146540lfm.601.1632431373934;
 Thu, 23 Sep 2021 14:09:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210917115820.GA27137@kili>
In-Reply-To: <20210917115820.GA27137@kili>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 23 Sep 2021 16:08:49 -0500
Message-ID: <CAH2r5mvxjEH_QCdoURVgvf4uRTTrApW8kzrC0KpVBxOXbWTuWg@mail.gmail.com>
Subject: Re: [bug report] cifs: refactor create_sd_buf() and and avoid
 corrupting the buffer
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000002a0d8705ccb00c9b"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000002a0d8705ccb00c9b
Content-Type: text/plain; charset="UTF-8"

Fix attached.   Harmless in some sense because lengths are the same,
but is easier to read/understand with the change you suggest.


On Fri, Sep 17, 2021 at 9:19 AM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> Hello Ronnie Sahlberg,
>
> The patch ea64370bcae1: "cifs: refactor create_sd_buf() and and avoid
> corrupting the buffer" from Nov 30, 2020, leads to the following
> Smatch static checker warning:
>
>         fs/smbfs_client/smb2pdu.c:2425 create_sd_buf()
>         warn: struct type mismatch 'smb3_acl vs cifs_acl'
>
> fs/smbfs_client/smb2pdu.c
>     2344 static struct crt_sd_ctxt *
>     2345 create_sd_buf(umode_t mode, bool set_owner, unsigned int *len)
>     2346 {
>     2347         struct crt_sd_ctxt *buf;
>     2348         __u8 *ptr, *aclptr;
>     2349         unsigned int acelen, acl_size, ace_count;
>     2350         unsigned int owner_offset = 0;
>     2351         unsigned int group_offset = 0;
>     2352         struct smb3_acl acl;
>                  ^^^^^^^^^^^^^^^^^^^
>
>     2353
>     2354         *len = roundup(sizeof(struct crt_sd_ctxt) + (sizeof(struct cifs_ace) * 4), 8);
>     2355
>     2356         if (set_owner) {
>     2357                 /* sizeof(struct owner_group_sids) is already multiple of 8 so no need to round */
>     2358                 *len += sizeof(struct owner_group_sids);
>     2359         }
>     2360
>     2361         buf = kzalloc(*len, GFP_KERNEL);
>     2362         if (buf == NULL)
>     2363                 return buf;
>     2364
>     2365         ptr = (__u8 *)&buf[1];
>     2366         if (set_owner) {
>     2367                 /* offset fields are from beginning of security descriptor not of create context */
>     2368                 owner_offset = ptr - (__u8 *)&buf->sd;
>     2369                 buf->sd.OffsetOwner = cpu_to_le32(owner_offset);
>     2370                 group_offset = owner_offset + offsetof(struct owner_group_sids, group);
>     2371                 buf->sd.OffsetGroup = cpu_to_le32(group_offset);
>     2372
>     2373                 setup_owner_group_sids(ptr);
>     2374                 ptr += sizeof(struct owner_group_sids);
>     2375         } else {
>     2376                 buf->sd.OffsetOwner = 0;
>     2377                 buf->sd.OffsetGroup = 0;
>     2378         }
>     2379
>     2380         buf->ccontext.DataOffset = cpu_to_le16(offsetof(struct crt_sd_ctxt, sd));
>     2381         buf->ccontext.NameOffset = cpu_to_le16(offsetof(struct crt_sd_ctxt, Name));
>     2382         buf->ccontext.NameLength = cpu_to_le16(4);
>     2383         /* SMB2_CREATE_SD_BUFFER_TOKEN is "SecD" */
>     2384         buf->Name[0] = 'S';
>     2385         buf->Name[1] = 'e';
>     2386         buf->Name[2] = 'c';
>     2387         buf->Name[3] = 'D';
>     2388         buf->sd.Revision = 1;  /* Must be one see MS-DTYP 2.4.6 */
>     2389
>     2390         /*
>     2391          * ACL is "self relative" ie ACL is stored in contiguous block of memory
>     2392          * and "DP" ie the DACL is present
>     2393          */
>     2394         buf->sd.Control = cpu_to_le16(ACL_CONTROL_SR | ACL_CONTROL_DP);
>     2395
>     2396         /* offset owner, group and Sbz1 and SACL are all zero */
>     2397         buf->sd.OffsetDacl = cpu_to_le32(ptr - (__u8 *)&buf->sd);
>     2398         /* Ship the ACL for now. we will copy it into buf later. */
>     2399         aclptr = ptr;
>     2400         ptr += sizeof(struct cifs_acl);
>     2401
>     2402         /* create one ACE to hold the mode embedded in reserved special SID */
>     2403         acelen = setup_special_mode_ACE((struct cifs_ace *)ptr, (__u64)mode);
>     2404         ptr += acelen;
>     2405         acl_size = acelen + sizeof(struct smb3_acl);
>                                             ^^^^^^^^^^^^^^^
>     2406         ace_count = 1;
>     2407
>     2408         if (set_owner) {
>     2409                 /* we do not need to reallocate buffer to add the two more ACEs. plenty of space */
>     2410                 acelen = setup_special_user_owner_ACE((struct cifs_ace *)ptr);
>     2411                 ptr += acelen;
>     2412                 acl_size += acelen;
>     2413                 ace_count += 1;
>     2414         }
>     2415
>     2416         /* and one more ACE to allow access for authenticated users */
>     2417         acelen = setup_authusers_ACE((struct cifs_ace *)ptr);
>     2418         ptr += acelen;
>     2419         acl_size += acelen;
>     2420         ace_count += 1;
>     2421
>     2422         acl.AclRevision = ACL_REVISION; /* See 2.4.4.1 of MS-DTYP */
>     2423         acl.AclSize = cpu_to_le16(acl_size);
>     2424         acl.AceCount = cpu_to_le16(ace_count);
> --> 2425         memcpy(aclptr, &acl, sizeof(struct cifs_acl));
>                                       ^^^^^^^^^^^^^^^^^^^^^^^
> smb3_acl and cifs_acl structs are both 8 bytes, but their data is quite
> different.
>
> (This old warnings are all showing up as new warnings because the file
> was moved).
>
>     2426
>     2427         buf->ccontext.DataLength = cpu_to_le32(ptr - (__u8 *)&buf->sd);
>     2428         *len = roundup(ptr - (__u8 *)buf, 8);
>     2429
>     2430         return buf;
>     2431 }
>
> regards,
> dan carpenter



-- 
Thanks,

Steve

--0000000000002a0d8705ccb00c9b
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-correct-smb3-ACL-security-descriptor.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-correct-smb3-ACL-security-descriptor.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ktxfgjgy0>
X-Attachment-Id: f_ktxfgjgy0

RnJvbSBlZGE1NmRhMGYyYzVhNmRjY2FhODI1ODMzZjg3YzNlOWJlM2RjNzIxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgMjMgU2VwIDIwMjEgMTY6MDA6MzEgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBjb3JyZWN0IHNtYjMgQUNMIHNlY3VyaXR5IGRlc2NyaXB0b3IKCkFkZHJlc3Mgd2Fybmlu
ZzoKCiAgICAgICAgZnMvc21iZnNfY2xpZW50L3NtYjJwZHUuYzoyNDI1IGNyZWF0ZV9zZF9idWYo
KQogICAgICAgIHdhcm46IHN0cnVjdCB0eXBlIG1pc21hdGNoICdzbWIzX2FjbCB2cyBjaWZzX2Fj
bCcKClBvaW50ZWQgb3V0IGJ5IERhbiBDYXJwZW50ZXIgdmlhIHNtYXRjaCBjb2RlIGFuYWx5c2lz
IHRvb2wKClJlcG9ydGVkLWJ5OiBEYW4gQ2FycGVudGVyIDxkYW4uY2FycGVudGVyQG9yYWNsZS5j
b20+ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4K
LS0tCiBmcy9jaWZzL3NtYjJwZHUuYyB8IDQgKystLQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0
aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJwZHUuYyBi
L2ZzL2NpZnMvc21iMnBkdS5jCmluZGV4IDY3MmFlNzhlODY2YS4uNzgyOWM1OTBlZWFjIDEwMDY0
NAotLS0gYS9mcy9jaWZzL3NtYjJwZHUuYworKysgYi9mcy9jaWZzL3NtYjJwZHUuYwpAQCAtMjM5
Nyw3ICsyMzk3LDcgQEAgY3JlYXRlX3NkX2J1Zih1bW9kZV90IG1vZGUsIGJvb2wgc2V0X293bmVy
LCB1bnNpZ25lZCBpbnQgKmxlbikKIAlidWYtPnNkLk9mZnNldERhY2wgPSBjcHVfdG9fbGUzMihw
dHIgLSAoX191OCAqKSZidWYtPnNkKTsKIAkvKiBTaGlwIHRoZSBBQ0wgZm9yIG5vdy4gd2Ugd2ls
bCBjb3B5IGl0IGludG8gYnVmIGxhdGVyLiAqLwogCWFjbHB0ciA9IHB0cjsKLQlwdHIgKz0gc2l6
ZW9mKHN0cnVjdCBjaWZzX2FjbCk7CisJcHRyICs9IHNpemVvZihzdHJ1Y3Qgc21iM19hY2wpOwog
CiAJLyogY3JlYXRlIG9uZSBBQ0UgdG8gaG9sZCB0aGUgbW9kZSBlbWJlZGRlZCBpbiByZXNlcnZl
ZCBzcGVjaWFsIFNJRCAqLwogCWFjZWxlbiA9IHNldHVwX3NwZWNpYWxfbW9kZV9BQ0UoKHN0cnVj
dCBjaWZzX2FjZSAqKXB0ciwgKF9fdTY0KW1vZGUpOwpAQCAtMjQyMiw3ICsyNDIyLDcgQEAgY3Jl
YXRlX3NkX2J1Zih1bW9kZV90IG1vZGUsIGJvb2wgc2V0X293bmVyLCB1bnNpZ25lZCBpbnQgKmxl
bikKIAlhY2wuQWNsUmV2aXNpb24gPSBBQ0xfUkVWSVNJT047IC8qIFNlZSAyLjQuNC4xIG9mIE1T
LURUWVAgKi8KIAlhY2wuQWNsU2l6ZSA9IGNwdV90b19sZTE2KGFjbF9zaXplKTsKIAlhY2wuQWNl
Q291bnQgPSBjcHVfdG9fbGUxNihhY2VfY291bnQpOwotCW1lbWNweShhY2xwdHIsICZhY2wsIHNp
emVvZihzdHJ1Y3QgY2lmc19hY2wpKTsKKwltZW1jcHkoYWNscHRyLCAmYWNsLCBzaXplb2Yoc3Ry
dWN0IHNtYjNfYWNsKSk7CiAKIAlidWYtPmNjb250ZXh0LkRhdGFMZW5ndGggPSBjcHVfdG9fbGUz
MihwdHIgLSAoX191OCAqKSZidWYtPnNkKTsKIAkqbGVuID0gcm91bmR1cChwdHIgLSAoX191OCAq
KWJ1ZiwgOCk7Ci0tIAoyLjMwLjIKCg==
--0000000000002a0d8705ccb00c9b--
