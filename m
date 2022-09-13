Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DDA0C6FA8A
	for <linux-cifs@archiver.kernel.org>; Tue, 13 Sep 2022 09:40:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbiIMJkN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 13 Sep 2022 05:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231745AbiIMJkG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 13 Sep 2022 05:40:06 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D10B2BB26
        for <linux-cifs@vger.kernel.org>; Tue, 13 Sep 2022 02:40:03 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4MRdgN6DJRzKCp5
        for <linux-cifs@vger.kernel.org>; Tue, 13 Sep 2022 17:38:08 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.170])
        by APP2 (Coremail) with SMTP id Syh0CgC3VW_uTyBjIj4hAw--.48825S4;
        Tue, 13 Sep 2022 17:40:00 +0800 (CST)
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     linux-cifs@vger.kernel.org, zhangxiaoxu5@huawei.com,
        sfrench@samba.org, pc@cjr.nz, lsahlber@redhat.com,
        sprasad@microsoft.com, rohiths@microsoft.com, smfrench@gmail.com,
        tom@talpey.com, linkinjeon@kernel.org, hyc.lee@gmail.com
Subject: [PATCH v5 0/5] Fix some bug in FSCTL_VALIDATE_NEGOTIATE_INFO handler
Date:   Tue, 13 Sep 2022 18:40:54 +0800
Message-Id: <20220913104059.2545304-1-zhangxiaoxu5@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: Syh0CgC3VW_uTyBjIj4hAw--.48825S4
X-Coremail-Antispam: 1UD129KBjvdXoWrKFy5ZF1kCw1ruw4UuryxGrg_yoWfKwb_GF
        WkXa4rZ3y5Xa1ftFyUtw1F9ryxta1xKFy3Jas7tF48JrZxAF1fJw4xX393WFy8Za1qgr43
        Gr1aqry8Ar4qgjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbsxYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
        Y4v20xvaj40_JFC_Wr1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
        A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
        67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
        0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IY
        c2Ij64vIr41l42xK82IY64kExVAvwVAq07x20xyl4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2
        IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v2
        6r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2
        IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2
        jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0x
        ZFpf9x07UQVyxUUUUU=
Sender: zhangxiaoxu@huaweicloud.com
X-CM-SenderInfo: x2kd0wp0ld053x6k3tpzhluzxrxghudrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

v4->v5: reorder the patch; 
	add check in smb2_ioctl() to ensure no oob read to DialectCount
v3->v4: Fix the wrong sizeof validate_negotiate_info_req in ksmbd
v2->v3: refactor the dialects in struct validate_negotiate_info_req to
	variable array
v1->v2: fix some bug in ksmbd when handle FSCTL_VALIDATE_NEGOTIATE_INFO
	message

Zhang Xiaoxu (5):
  cifs: Fix the error length of VALIDATE_NEGOTIATE_INFO message
  ksmbd: Fix wrong return value in smb2_ioctl()
  ksmbd: Fix FSCTL_VALIDATE_NEGOTIATE_INFO message length check in
    smb2_ioctl()
  cifs: Add neg dialects info to smb version values
  cifs: Refactor dialects in validate_negotiate_info_req to variable
    array

 fs/cifs/cifsglob.h        |  2 ++
 fs/cifs/smb2ops.c         | 35 ++++++++++++++++++++++
 fs/cifs/smb2pdu.c         | 61 +++++++--------------------------------
 fs/ksmbd/smb2pdu.c        | 14 +++++----
 fs/smbfs_common/smb2pdu.h |  3 +-
 5 files changed, 58 insertions(+), 57 deletions(-)

-- 
2.31.1

