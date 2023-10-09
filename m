Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19DEDE95A8D
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Oct 2023 03:39:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344981AbjJIDjE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 8 Oct 2023 23:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344883AbjJIDjD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 8 Oct 2023 23:39:03 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE155A3
        for <linux-cifs@vger.kernel.org>; Sun,  8 Oct 2023 20:39:01 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-503397ee920so5069758e87.1
        for <linux-cifs@vger.kernel.org>; Sun, 08 Oct 2023 20:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696822739; x=1697427539; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=F25uLhiY2el/6VY57mqoqlyozxz7V8aXB4U/G+qj6wg=;
        b=YCYaJ5GM8z3DF9pkgjLNUtH2jmXlzppv8ZLmYozZ/8tcWHMHuvQ19BLVGjrphImnh2
         862Tedqb5lQ9Q5CJgxVurcjt9ESHFpo3CYMHKYXXOTxO9ithdvYyiaK7Hsu1qU0FImXU
         quBVanlt6WoTCOWM9+/9Z1EQZW70nlABV9puaddGIoStxcxFZ7s4V1oJ8kdM5wrfIz2M
         FSsx6SrEwhGnyD4RvQm2vbVD0QjM16K7ohXgCDkjqQkMQtBW2nmF0NK3so3Ncok/gnSY
         uSTAUG9DncFywrw1Z98PUuTDNxhpvWl6BI3OXCDaoICMcjMj3a01Djr8vItHgoJRdxMt
         LBNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696822739; x=1697427539;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F25uLhiY2el/6VY57mqoqlyozxz7V8aXB4U/G+qj6wg=;
        b=X3u62PRKG1AXGY2msEP9I5xyOJT0s4FY9cqLX9O0zw9ny8DxJTtZ5KjIFPdpILZyAt
         kvridilp/PR9mlMR50P3/jKNH6YJJ3tYQW+KPZsVtUtvbUDU6p37Y2MNY4p2ToFDalta
         ElU02yBiGyyLPOuTTMqqR6n3/jqTFMJ9FNGGBU6f12O4CsEWejg8Pg0K1ONBHX7WFpQD
         Ecb26rCNCR2fFK8ol21pZ37CHMKMTm2u2K8k/rk+3Sn0MAWKCkXjU3LW/BBFSfMPrRXp
         37LecVkwBvQN22V9h6sF8qKzRYpgYW1b/FH2vW5igzpb7QLHeulm7ooe3mQBm3zsEX7h
         RT9g==
X-Gm-Message-State: AOJu0YxswCM4NxywK88J2F0QtLVixN5OsPT4sgOWrzs1yoKd/30pyhXb
        nnh6GSlMI40BnBij4PdV63nu5RhBAuc5VAtNrCsESs7OSyA=
X-Google-Smtp-Source: AGHT+IFVIBO14V13vJBlhclqeZVm2nowlKI3tTxF61ZqBKFZPCuJlVugyd60rvYOoCB+Ag/STZzgZnZLCydVXCPmnoY=
X-Received: by 2002:a19:435c:0:b0:500:91c1:9642 with SMTP id
 m28-20020a19435c000000b0050091c19642mr11859253lfj.21.1696822738602; Sun, 08
 Oct 2023 20:38:58 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 8 Oct 2023 22:38:47 -0500
Message-ID: <CAH2r5msM0UXTF2nLCSMb1KdjSP9ehVmuc2TL2RA_YG2Dww__Qw@mail.gmail.com>
Subject: SMB2_SHAREFLAG_RESTRICT_EXCLUSIVE_OPENS to improve POSIX compat
To:     samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Has there been any previous discussion about the share flag
          "SMB2_SHAREFLAG_RESTRICT_EXCLUSIVE_OPENS"
to see if it could help improve POSIX compatibility if it could be set
on a per-share basis in Samba and/or ksmbd?

-- 
Thanks,

Steve
