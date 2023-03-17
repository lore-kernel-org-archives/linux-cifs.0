Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5C64C74A5B
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Mar 2023 11:15:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbjCQLP5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 17 Mar 2023 07:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjCQLPz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 17 Mar 2023 07:15:55 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE13746AD
        for <linux-cifs@vger.kernel.org>; Fri, 17 Mar 2023 04:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=Uf8nP0x72lU0LWG3wz/upIc80VUCQ9OuKnarTqW+sTc=; b=OJpGi4uprQcOuPOffzkF2Sun3L
        M89ayeMaQSKvmk2NadsOOaPvhMSvY5jDdDe/pBzhzpxxQ3015MtB+qB0VU003pvcxKiIy1pkBjPab
        iqussPCqoqaP84jIlFsUqQ00H9GE3ljPHk7sU1+tp3CJBX9zhh9AcoC6n61rvRa2Sz9JUZqtvidhq
        KfhVkzv/XIMX6UP2LJK4PHM0dkbHh7wsQoSpNnJVOtaUJ3Ej1323CmLZV7+jP5Efn5sU2VwecoT8n
        O/m5DjcFdymtx+4ATCkv1sFVmoKHb4nQOxySb5elnfkbYUvNcj3BrD5RESW2vpkxthJ4E80PbHQtk
        We9h5sZme/2OG6ztZqFLlQy9AIt2+ML1Si6LLA1/9KVPJnXpLrg8pVcR9vlIa8gINdydrDbjEWKPN
        aXLjp2RqPFRbSb8M91oGRCrPOSiIe70KiUZp+/Cscc+5Mvx+iMKpmnj7m3efZcUjfELmA7NGKwPgM
        dP+7kpgh9oDNpndu+260Qmnv;
Received: from [2a01:4f8:252:410e::177:224] (port=37520 helo=atb-devel-224..) 
        by hr2.samba.org with esmtp (Exim)
        id 1pd83n-003p4x-Lh; Fri, 17 Mar 2023 11:15:47 +0000
From:   Volker Lendecke <vl@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Volker Lendecke <vl@samba.org>
Subject: [PATCH 0/7] Avoid a few casts from void *
Date:   Fri, 17 Mar 2023 11:15:21 +0000
Message-Id: <cover.1679051552.git.vl@samba.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We should not go through void * without type-checking if it's not
really necessary.

Volker Lendecke (7):
  cifs: Avoid a cast in add_lease_context()
  cifs: Avoid a cast in add_durable_context()
  cifs: Avoid a cast in add_posix_context()
  cifs: Avoid a cast in add_sd_context()
  cifs: Avoid a cast in add_durable_v2_context()
  cifs: Avoid a cast in add_durable_reconnect_v2_context()
  cifs: Avoid a cast in add_query_id_context()

 fs/cifs/smb2pdu.c | 55 ++++++++++++++++++++++++++---------------------
 1 file changed, 30 insertions(+), 25 deletions(-)

-- 
2.30.2

