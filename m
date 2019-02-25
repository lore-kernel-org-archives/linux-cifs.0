Return-Path: <SRS0=eDtx=RA=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6814CC43381
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Feb 2019 07:25:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 335DA2087C
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Feb 2019 07:25:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nNztlUKH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728557AbfBYHZQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Feb 2019 02:25:16 -0500
Received: from mail-pf1-f176.google.com ([209.85.210.176]:43941 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728544AbfBYHZQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 25 Feb 2019 02:25:16 -0500
Received: by mail-pf1-f176.google.com with SMTP id q17so4060321pfh.10
        for <linux-cifs@vger.kernel.org>; Sun, 24 Feb 2019 23:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=TT4qCg7WK3T/yLV9u1pWRKTgv7iEJTqMjjAL2uhRv50=;
        b=nNztlUKHPdFBY0VRb5qjHjhWPOB3Tx42QsYtzpq6MVUJ8OR8Q73anOnuSR3+fkZYBV
         /DOzAts26EnZL4xsGecUT/35gBrZ3f1CnHg6qMH8+YeywzzDDDIzJ+M3OuI+YryMaJ4D
         DN/Hl1MrREjvXryJl9htWC8/eQ4h5yvJC3/eojWtqtwHUsS+L/IMxbYocssPDSLsMi3q
         jPO+vmq4yu+90GXtSzO1ZUY6eN1UV9APVD1HO/Cuy+ur/Bt2ppC5uj1fP573SvrSWcuM
         cOxHGTtBPLIKoig/7uMtIUPG+aReHJoNPNrZk/Elon0SyyrgWD0rXk7qbAhFdKm2gADr
         ZsOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=TT4qCg7WK3T/yLV9u1pWRKTgv7iEJTqMjjAL2uhRv50=;
        b=Fp79ij5ALgMW6ALBor9qaTfmr8LF9tjT8fPvJ7Ne1p7CVlpkM4QZLnhjfwphro090M
         o+fez9K3rrX1D6hUSlXlg8RjXDB/sIL8dmlk4ngB9krLnFsiwWg+4ILMHlWf1m3Xj3PI
         b8wXzgeSrxXKeHpRHVu0pit36Wyt+uNZcLyGSQ2uasLwKDsQf09JowGWUvOWmDr6TjIp
         kMtUR2fg9KskXlRH3Sy4YEoszy7wyVPBkaMpU3iimXnm+vsMAwx5WhZNjgmFc0mVyHD+
         Cy+53ZMQy4VA6ksjd61yaROUtZrmZ4K5DQSUlcLPdwiklPXc4eMwpVIGBDvYkoWes878
         Lcow==
X-Gm-Message-State: AHQUAuYSyClSrWZK9FoTWz3todyBXfeN4NvLlrLuoPjX7K3U0pjr9/C9
        /uJABnvLZtHH7BjQ5GzwoQhYcanwAsf2J1VOf3JOyJ38
X-Google-Smtp-Source: AHgI3Ib/wkSZi+EPUm15SXt5HAtvMFoMmiqGAAT1/RNzTQNmxQcTL0aPfb6I+XOK8xS2Acq48RRcr0RuZyrL5ptBNo8=
X-Received: by 2002:a63:8743:: with SMTP id i64mr13613197pge.69.1551079515657;
 Sun, 24 Feb 2019 23:25:15 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 25 Feb 2019 01:25:04 -0600
Message-ID: <CAH2r5mt+4p=KBumSV3aqE35my8ypnLy9NDJnEyTuh_vg4kP6VQ@mail.gmail.com>
Subject: Testing your tree with Linux client
To:     Jeremy Allison <jra@samba.org>,
        samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Other than the world write flag being masked off (0777--> 0775) and
the setuid/setgid/sticky bits being masked off, file create also
looked fine.  See the local view of newly created files

-rwxr-xr--  1 testuser testuser          0 Feb 24 20:15 01754
-r--r-----  1 testuser testuser          0 Feb 24 20:15 0440
-rwxr-----  1 testuser testuser          0 Feb 24 20:15 0740
-rwxrwx---  1 testuser testuser          0 Feb 24 20:15 0770
-rwxrwxr-x  1 testuser testuser          0 Feb 24 20:15 0777
-rwxrwx---  1 testuser testuser          0 Feb 24 20:15 07770


-- 
Thanks,

Steve
