Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC02BCA0FE6
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Sep 2023 06:36:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234905AbjIAGgN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Sep 2023 02:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231775AbjIAGgM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Sep 2023 02:36:12 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C05F210CE
        for <linux-cifs@vger.kernel.org>; Thu, 31 Aug 2023 23:36:09 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id 38308e7fff4ca-2bcd7a207f7so26801681fa.3
        for <linux-cifs@vger.kernel.org>; Thu, 31 Aug 2023 23:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693550168; x=1694154968; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pkPIUJfy1166r5A1MdmjbLromN12vE5kJ2Dr6P1AFzk=;
        b=ldOoTuE6uLo+ISvvflQa8rrBhOZaTmQsVmDk3cAX4etcRMYlnVCntGwcw/T3/AFwEJ
         /5Y9/E3YSkAeiJcm1gTrPAJD8yK1Bj/xPoJIRFnhEBwgckxw76RxMqJDkphHobV6bz4y
         BvPOyN2wQWsud2ImVJ79EWTUPM5FbFy3Sc0lwvZt+pByAEs1DGOTfmGcjbO01lsBAOKM
         UCrrkE7Tt7vt/FyGvDaFuUBn2a//Rv+zdCPdWVM9ZdcalXs4EFe+RGgeid2DlnbZVh5e
         okOGjRbwo/RwSFydDg9Cj332H1VWpEIdNRpCtspcxio2cYmiawulFqF2PyV0PSSqACxD
         2eBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693550168; x=1694154968;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pkPIUJfy1166r5A1MdmjbLromN12vE5kJ2Dr6P1AFzk=;
        b=Y2WK+KBnQFmSZDO7+sK+92EdJk12ggLyROaj9HEEX+S5UIrvGDYrM4tyKOUQ8bOJDh
         JPvzq8aKSFZYYXCrA1WIlBeo6hlwRzPRv7W8GjbVrllITETpc7hCWqXuBwSA/6NqPG3G
         /j00NkcQFNu2EdbweSHtwc0dW2xxhhocr1IATODZF7rOUmjIxwsTDoDOmRnFWMfnKlZL
         O5xWLZYKEEotVjHWxWJPYT+rjEDW0zAB7kUYZupbMFFxV4THLVJlG2SMh1ypKQHcJSBL
         1fuYeP5VSsbPB0HHV7BuK6Og8iNFeYQyXpnaxlf977zcKdR7KmqGODGOXUqK5o1Ty3UT
         X4wg==
X-Gm-Message-State: AOJu0YyyNRIFUjGJMTOZeKmSgEEvnJGHSlphMoDj1su5U3C/flfA2qY/
        47A/UfMlgh3OIws1/Lt0zpyR9JDF3buXSEw5+ADMQCZKQFEaGmEw
X-Google-Smtp-Source: AGHT+IF1w3cc4uXMlIsR9jt7kWzNFiYLkSgU5YJHikdzXr7cTdtWziD3XvLWYTDukOitVX5zFs9szmMhYGPSlT1ldts=
X-Received: by 2002:a2e:8356:0:b0:2bc:bc7e:e2df with SMTP id
 l22-20020a2e8356000000b002bcbc7ee2dfmr1027171ljh.33.1693550167468; Thu, 31
 Aug 2023 23:36:07 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 1 Sep 2023 01:35:56 -0500
Message-ID: <CAH2r5mu0yS8zvrTSRcVqQEgDv_Qo8zmxUaJAajgLNoYEz7NOgg@mail.gmail.com>
Subject: [PATCH][SMB3] add dynamic tracepoint for smb3_qfs_done
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        Bharath S M <bharathsm@microsoft.com>
Content-Type: multipart/mixed; boundary="000000000000244b2b06044660c8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000244b2b06044660c8
Content-Type: text/plain; charset="UTF-8"

Add trace point for queryfs (statfs)

In debugging a recent performance problem with statfs, it would have
been helpful to be able to trace the smb3 query fs info request
more narrowly.  Add a trace point "smb3_qfs_done"

Which displays:

     stat-68950   [008] .....  1472.360598: smb3_qfs_done: xid=14
sid=0xaa9765e4 tid=0x95a76f54 unc_name=\\localhost\test rc=0


-- 
Thanks,

Steve

--000000000000244b2b06044660c8
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-add-trace-point-for-queryfs-statfs.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-add-trace-point-for-queryfs-statfs.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lm0815xj0>
X-Attachment-Id: f_lm0815xj0

RnJvbSAxZGM0ZWNjNDY3ODg4YWQ5ODY5N2MyNjljNDNjOTEyNDk2ZTY1NGEwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgMSBTZXAgMjAyMyAwMToyOToxNyAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjM6IGFkZCB0cmFjZSBwb2ludCBmb3IgcXVlcnlmcyAoc3RhdGZzKQoKSW4gZGVidWdnaW5nIGEg
cmVjZW50IHBlcmZvcm1hbmNlIHByb2JsZW0gd2l0aCBzdGF0ZnMsIGl0IHdvdWxkIGhhdmUKYmVl
biBoZWxwZnVsIHRvIGJlIGFibGUgdG8gdHJhY2UgdGhlIHNtYjMgcXVlcnkgZnMgaW5mbyByZXF1
ZXN0Cm1vcmUgbmFycm93bHkuICBBZGQgYSB0cmFjZSBwb2ludCAic21iM19xZnNfZG9uZSIKCldo
aWNoIGRpc3BsYXlzOgoKIHN0YXQtNjg5NTAgICBbMDA4XSAuLi4uLiAgMTQ3Mi4zNjA1OTg6IHNt
YjNfcWZzX2RvbmU6IHhpZD0xNCBzaWQ9MHhhYTk3NjVlNCB0aWQ9MHg5NWE3NmY1NCB1bmNfbmFt
ZT1cXGxvY2FsaG9zdFx0ZXN0IHJjPTAKClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3Rm
cmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9zbWIvY2xpZW50L3NtYjJvcHMuYyB8IDEgKwog
ZnMvc21iL2NsaWVudC90cmFjZS5oICAgfCAyICstCiAyIGZpbGVzIGNoYW5nZWQsIDIgaW5zZXJ0
aW9ucygrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvc21iMm9w
cy5jIGIvZnMvc21iL2NsaWVudC9zbWIyb3BzLmMKaW5kZXggMGY2MmJjMzczYWQwLi5lNWQ5OWNm
ZGQzMWIgMTAwNjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvc21iMm9wcy5jCisrKyBiL2ZzL3NtYi9j
bGllbnQvc21iMm9wcy5jCkBAIC0yNjgxLDYgKzI2ODEsNyBAQCBzbWIyX3F1ZXJ5ZnMoY29uc3Qg
dW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAkJc21iMl9jb3B5X2Zz
X2luZm9fdG9fa3N0YXRmcyhpbmZvLCBidWYpOwogCiBxZnNfZXhpdDoKKwl0cmFjZV9zbWIzX3Fm
c19kb25lKHhpZCwgdGNvbi0+dGlkLCB0Y29uLT5zZXMtPlN1aWQsIHRjb24tPnRyZWVfbmFtZSwg
cmMpOwogCWZyZWVfcnNwX2J1ZihidWZ0eXBlLCByc3BfaW92Lmlvdl9iYXNlKTsKIAlyZXR1cm4g
cmM7CiB9CmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L3RyYWNlLmggYi9mcy9zbWIvY2xpZW50
L3RyYWNlLmgKaW5kZXggZTY3MWJkMTZmMDBjLi5hN2U0NzU1YmVkMGYgMTAwNjQ0Ci0tLSBhL2Zz
L3NtYi9jbGllbnQvdHJhY2UuaAorKysgYi9mcy9zbWIvY2xpZW50L3RyYWNlLmgKQEAgLTY5MSw3
ICs2OTEsNyBAQCBERUZJTkVfRVZFTlQoc21iM190Y29uX2NsYXNzLCBzbWIzXyMjbmFtZSwgICAg
XAogCVRQX0FSR1MoeGlkLCB0aWQsIHNlc2lkLCB1bmNfbmFtZSwgcmMpKQogCiBERUZJTkVfU01C
M19UQ09OX0VWRU5UKHRjb24pOwotCitERUZJTkVfU01CM19UQ09OX0VWRU5UKHFmc19kb25lKTsK
IAogLyoKICAqIEZvciBzbWIyL3NtYjMgb3BlbiAoaW5jbHVkaW5nIGNyZWF0ZSBhbmQgbWtkaXIp
IGNhbGxzCi0tIAoyLjM5LjIKCg==
--000000000000244b2b06044660c8--
