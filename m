Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F13CC77B73
	for <linux-cifs@archiver.kernel.org>; Thu, 20 Apr 2023 17:06:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbjDTRG2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 20 Apr 2023 13:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbjDTRG1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 20 Apr 2023 13:06:27 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42739D2
        for <linux-cifs@vger.kernel.org>; Thu, 20 Apr 2023 10:06:26 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id a11so2712581ybm.3
        for <linux-cifs@vger.kernel.org>; Thu, 20 Apr 2023 10:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682010385; x=1684602385;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=htNzB9PcNqCUblfzs0Jwo1p3dEkk4CrS1NPDAoBPr2U=;
        b=QxPc0E2hRiDFwYF5k0K5uEFnJHJpZReWCGHUaafihdbdMRtwiEhz5Gz4HvWZs73x/Y
         ngl9XHpGdICh1I4dx2aiZSRDdq7Mh7w6JkKaP4sYXBnf2VtOA7dBY2BP8cDQGoBwifS2
         QKq4QYct2gzAAbf9C+osVQ0fXfSli3KEuQKiFjRHceOUeary++yYwrvsTuY5uhWCbIqj
         Od8aeznYLHDZDH474L39oS+fblHPIo8bfoyRmdOR/y2HYloXzlpRvGXZbzEjFSw/MnHY
         +tz/N3491a7s8sHPntPaj9kBlThbz+YT888xt+beJxfQVM6LFiBjlUCE4N0UjNxmEJT/
         knXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682010385; x=1684602385;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=htNzB9PcNqCUblfzs0Jwo1p3dEkk4CrS1NPDAoBPr2U=;
        b=Id6Tcu8KsO8C3BdaeJyzjRUjlMzZ4sKrMd82ZdCoVKDoc/SA/ofTaQmZa7eQEuPHJi
         hr7jvQULRl8bgrMWw9FKEJaajUCxM7JcNe0uDNQ0ilWFdDLNm4Bokk2gbLm1Rhv0uU83
         fFU4XDYEggAaeYgXWyntmuXbZcgWwFEeZP0Hp7I9Tz1RGE4ExYzp3pwHYE6zyD/iQUml
         sW3q8/+TCyIZ603Ag6JFQrOiBtM27xO1ihUJVWp9XLJxvWh7wFRGBv+akcR1TL18rKFP
         5yiSTaamzvSkZoZ5C0o01w2U9njIRKifcHoylablADxxxkZnm1ZMc+N//FJVo25QXPY8
         5JWw==
X-Gm-Message-State: AAQBX9d36LIEJQT3Foyt4im6wyDlJxvjN9N7Cyug1MPTM0VruESqZVgJ
        VCQ6gXzeeBXEN2f5ar3cAWqc96FGk7G42AlqIKM=
X-Google-Smtp-Source: AKy350ag7Q1kFsFiFK87vE5qAPjIHyAV/8dV/PD9UHLmDitWa1J35PJT6r5fTiRaWOgdDUQ7yGpRfhWx5t0KU3gqizM=
X-Received: by 2002:a25:ab6f:0:b0:b69:eb08:8f3b with SMTP id
 u102-20020a25ab6f000000b00b69eb088f3bmr2097383ybi.4.1682010385300; Thu, 20
 Apr 2023 10:06:25 -0700 (PDT)
MIME-Version: 1.0
References: <20230420160646.291053-1-bharathsm.hsk@gmail.com> <CAN05THRhV3hRcYVfx0_1A3dZPtVCBxtbpXvboAu34VdoKM3Mzg@mail.gmail.com>
In-Reply-To: <CAN05THRhV3hRcYVfx0_1A3dZPtVCBxtbpXvboAu34VdoKM3Mzg@mail.gmail.com>
From:   Bharath SM <bharathsm.hsk@gmail.com>
Date:   Thu, 20 Apr 2023 22:36:14 +0530
Message-ID: <CAGypqWyhzrMTW+aMK=NiKB2f5HZ45xuH_G-nEaTLc+tqNXTWPw@mail.gmail.com>
Subject: Re: [PATCH] SMB3: Add missing locks to protect deferred close file list
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     pc@cjr.nz, sfrench@samba.org, lsahlber@redhat.com,
        sprasad@microsoft.com, tom@talpey.com, linux-cifs@vger.kernel.org,
        Bharath SM <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Apr 20, 2023 at 9:54=E2=80=AFPM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> Looks good. Acked-by me.
>
> Can you add a "Fixes ..." line to the commit message.

cifs_del_deferred_close function has a critical section which modifies
the deferred close file list. We must acquire deferred_lock before
calling cifs_del_deferred_close function.

Fixes: ca08d0eac020 ("cifs: Fix memory leak on the deferred close")
Signed-off-by: Bharath SM <bharathsm@microsoft.com>
