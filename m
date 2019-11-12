Return-Path: <SRS0=+Q0n=ZE=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F4151C43331
	for <linux-cifs@archiver.kernel.org>; Tue, 12 Nov 2019 19:34:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C841D20818
	for <linux-cifs@archiver.kernel.org>; Tue, 12 Nov 2019 19:34:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JXJ9cJeG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbfKLTed (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 12 Nov 2019 14:34:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59128 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726958AbfKLTed (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 12 Nov 2019 14:34:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573587271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=T5DefNER+aV1euCWowrL7STfT7DW0q2UlUNjm6spyC8=;
        b=JXJ9cJeGxp0KqfmM9yuEQGAtYAhe9/BRJNfV1gHFNW2IDMns5r98FSKBO5IAnMHkt/iyV2
        P+Vb2qrlbiNz3yXAzwPYCKXTRHWZ/4GQwnW79hF7O8dw77XYGHZOiL7lzhqWqkan9bUZDa
        031BH+E1IhUdJDqnuJmJ9WR06aZgKSk=
Received: from mail-yw1-f69.google.com (mail-yw1-f69.google.com
 [209.85.161.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-I55CSb71MQG-nRmALnfEVg-1; Tue, 12 Nov 2019 14:34:30 -0500
Received: by mail-yw1-f69.google.com with SMTP id 202so14976568ywf.8
        for <linux-cifs@vger.kernel.org>; Tue, 12 Nov 2019 11:34:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=vmZLAqD1L7tNQ17Pu9kYcjSWeSH67xEYMADCwlwj9Ko=;
        b=RvKHbxO5Gs/W5Srbq70/uOMOJqtHKU1TFWzAos0ZXh3jPcjvi/cR5MAYja/fR9uKXa
         G8lPU6gQ1OF7dgW80bTV0IV8e+E2Dqpz8B+HL94udS/jDksbswdX1lCj0OEBpOig+TNp
         LT8pSozcofMwEt0rK1+xvm3Btg1LfkmWHVqONO9dv7j9DHMLHA6RH+jNvD2iWc3chKEJ
         9WI+oL1bDf8Wt7vqETDFmQsHP55ivRri9VquIO/LiDTbn4wwTKKg0uV/RZcvTlOsQB72
         wf5qU0pdFUeqreLa0r3PKVk5rl515dDmv0UTUrRxb5mEjCqOdsakaFox28EcjngVdOoU
         kfvA==
X-Gm-Message-State: APjAAAWfAFVdNeKmeHZqkvIVkI1hDFSeTelm/k3sbxxx/ykx3T7DMJvT
        oMYIjO2Rcd10niIDklQVj/bA1EsuIvUvOhtGVjr5fo8Jcpk5woAg2riz/7A6VgLQGy0usTkiyOR
        cAveO90qQeUo6CsuBlSmnQw==
X-Received: by 2002:a25:dd07:: with SMTP id u7mr16697331ybg.255.1573587269762;
        Tue, 12 Nov 2019 11:34:29 -0800 (PST)
X-Google-Smtp-Source: APXvYqxy+2EzJsrvURST7YvgYjCgmaL5Ir/ZlhQPQWu749jWSOmZp0fvivhiIfAvWh6EVnTB81vLtQ==
X-Received: by 2002:a25:dd07:: with SMTP id u7mr16697297ybg.255.1573587269161;
        Tue, 12 Nov 2019 11:34:29 -0800 (PST)
Received: from hut.sorensonfamily.com (198-0-247-150-static.hfc.comcastbusiness.net. [198.0.247.150])
        by smtp.gmail.com with ESMTPSA id 197sm8369099ywf.42.2019.11.12.11.34.28
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2019 11:34:28 -0800 (PST)
To:     linux-cifs <linux-cifs@vger.kernel.org>
From:   Frank Sorenson <sorenson@redhat.com>
Subject: A process killed while opening a file can result in leaked open
 handle on the server
Message-ID: <0326b8d9-d66c-1df0-2d04-91b9a861c10f@redhat.com>
Date:   Tue, 12 Nov 2019 13:34:27 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Language: en-US
X-MC-Unique: I55CSb71MQG-nRmALnfEVg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If a process opening a file is killed while waiting for a SMB2_CREATE
response from the server, the response may not be handled by the client,
leaking an open file handle on the server.

This can be reproduced with the following:

# mount //vm3/user1 /mnt/vm3 -overs=3D3,sec=3Dntlmssp,credentials=3D/root/.=
user1_smb_creds
# cd /mnt/vm3
# echo foo > foo

# for i in {1..100} ; do cat foo >/dev/null 2>&1 & sleep 0.0001 ; kill -9 $=
! ; done

(increase count if necessary--100 appears sufficient to cause multiple leak=
ed file handles)


The client will stop waiting for the response, and will output
the following when the response does arrive:

    CIFS VFS: Close unmatched open

on the server side, an open file handle is leaked.  If using samba,
the following will show these open files:


# smbstatus | grep -i Locked -A1000
Locked files:
Pid          Uid        DenyMode   Access      R/W        Oplock           =
SharePath   Name   Time
---------------------------------------------------------------------------=
-----------------------
25936        501        DENY_NONE  0x80        RDONLY     NONE             =
/home/user1   .   Tue Nov 12 12:29:24 2019
25936        501        DENY_NONE  0x80        RDONLY     NONE             =
/home/user1   .   Tue Nov 12 12:29:24 2019
25936        501        DENY_NONE  0x120089    RDONLY     LEASE(RWH)       =
/home/user1   foo   Tue Nov 12 12:29:24 2019
25936        501        DENY_NONE  0x120089    RDONLY     LEASE(RWH)       =
/home/user1   foo   Tue Nov 12 12:29:24 2019
25936        501        DENY_NONE  0x120089    RDONLY     LEASE(RWH)       =
/home/user1   foo   Tue Nov 12 12:29:24 2019
25936        501        DENY_NONE  0x120089    RDONLY     LEASE(RWH)       =
/home/user1   foo   Tue Nov 12 12:29:24 2019
25936        501        DENY_NONE  0x120089    RDONLY     LEASE(RWH)       =
/home/user1   foo   Tue Nov 12 12:29:24 2019


(also tracked https://bugzilla.redhat.com/show_bug.cgi?id=3D1771691)

Frank
--
Frank Sorenson
sorenson@redhat.com
Principal Software Maintenance Engineer
Global Support Services - filesystems
Red Hat

