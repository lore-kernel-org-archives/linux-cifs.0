Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799F436167E;
	Thu, 30 Jul 2026 02:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785377791; cv=none; b=gijhjSI5c8gscKQYa6dqmYXo1FQyRoGBPhg0bR8A+3ucduV7ogj7uD44T9DlaarbJcDiLlGo5aJXv++tcdeu1h5BvjQ0AWkMkYKxfn4ZD2obx9KX7PV2Jbr+OGehbVLQTp7XiZSxQgK4VvpaGGI9iXvkMIaPrdPu/5/h4goXCEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785377791; c=relaxed/simple;
	bh=tIE0kvK8di21nYfN1mDfvFuLoqdon/M0kilOMlOd+jk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BxaTDSXao2HqI5aqaYN1/BJy0g7JuZihJeNat3jh6McvJUutdF6cgTarpG4JN1/UOhN9Py4K98quTHqKnekAzIVBRiTlV9zTv/jCzAsDyCKWsjGXC/IQYfFnK1wyogPtFbrLgFfWDIAxG96epuogCl+/Mno1f3oJQNwSfVwfEQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: a4bf61688bbc11f1aa26b74ffac11d73-20260730
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:7538abc5-5c32-4c4b-b639-8dde5f45a6e9,IP:0,U
	RL:0,TC:0,Content:26,EDM:-20,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:6
X-CID-META: VersionHash:e7bac3a,CLOUDID:82a095a2b65cb794dcc0797b24774f97,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:81|82|83|102|850|865|898,TC:nil,Content:
	4|15|50,EDM:1|19,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:
	0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: a4bf61688bbc11f1aa26b74ffac11d73-20260730
X-User: yijiangshan@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <yijiangshan@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1452751522; Thu, 30 Jul 2026 10:16:15 +0800
From: Jiangshan Yi <yijiangshan@kylinos.cn>
To: smfrench@gmail.com
Cc: 13667453960@163.com,
	akpm@linux-foundation.org,
	bharathsm@microsoft.com,
	jlayton@kernel.org,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	samba-technical@lists.samba.org,
	sprasad@microsoft.com,
	tom@talpey.com,
	yijiangshan@kylinos.cn
Subject: Re: Re: [PATCH] smb: client: clear setuid/setgid bit on write with cifsacl/modefromsid/posix extensions
Date: Thu, 30 Jul 2026 10:16:12 +0800
Message-Id: <20260730021612.1946998-1-yijiangshan@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <CAH2r5mv962Lp+mLi2JCjvWhtJLbzLqwmjxYSCjSUyy_KLjAzuw@mail.gmail.com>
References: <CAH2r5mv962Lp+mLi2JCjvWhtJLbzLqwmjxYSCjSUyy_KLjAzuw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Thanks for the review, Steve.

The patch does not over-clear the setuid/setgid bits when root writes,
because the VFS layer already performs the CAP_FSETID check upstream
of the CIFS setattr code. No changes are needed to re-check for root
in the patch.

The sole producer of the ATTR_KILL_SUID / ATTR_KILL_SGID mask in the
write path is setattr_should_drop_suidgid() (fs/attr.c:63, referring
to mainline v7.2-rc5 / commit f5098b6bae76).  The local variable
"kill" there is a bitmask of ATTR_KILL_SUID | ATTR_KILL_SGID (not a
boolean), and the function ends with:

    int setattr_should_drop_suidgid(struct mnt_idmap *idmap,
                                    struct inode *inode)
    {
            umode_t mode = inode->i_mode;
            int kill = 0;

            /* suid always must be killed */
            if (unlikely(mode & S_ISUID))
                    kill = ATTR_KILL_SUID;

            kill |= setattr_should_drop_sgid(idmap, inode);

            if (unlikely(kill && !capable(CAP_FSETID) && S_ISREG(mode)))   /* line 75 */
                    return kill;

            return 0;
    }

The decisive condition is "!capable(CAP_FSETID)" on line 75.  A process
that holds CAP_FSETID (typically root) causes the function to return 0,
so the kill mask is never produced for root writes.

The full write-path call chain is:

  write()
    -> file_remove_privs()                 [fs/inode.c:2411]
      -> file_remove_privs_flags()         [fs/inode.c:2376]
        -> dentry_needs_remove_privs()     [fs/inode.c:2349]
          -> setattr_should_drop_suidgid() [fs/attr.c:63]
               |
               +-- !capable(CAP_FSETID) -> returns non-zero kill mask
               |      -> __remove_privs() -> notify_change(KILL_S*ID)
               |           -> KILL-to-MODE translation [fs/attr.c:499]
               |              -> cifs_setattr()  <-- patch modifies here
               |
               +-- capable(CAP_FSETID) [root] -> returns 0
                      -> kill == 0, __remove_privs() skipped
                           -> notify_change() not called
                                -> cifs_setattr_* not triggered  (*)

At the point marked (*), the ATTR_KILL_SUID / ATTR_KILL_SGID flags
never appear in the iattr passed to CIFS when root writes.  Therefore
the patched branch:

    if ((attrs->ia_valid & (ATTR_KILL_SUID|ATTR_KILL_SGID)) &&
        !((sbflags & (CIFS_MOUNT_CIFS_ACL | CIFS_MOUNT_MODE_FROM_SID)) ||
          cifs_sb_master_tcon(cifs_sb)->posix_extensions))
        attrs->ia_valid &= ~ATTR_MODE;

does not execute in the root-write scenario, so there is no risk of
incorrectly clearing bits that should be preserved.  The CIFS layer
does not need to duplicate the CAP_FSETID check that the VFS already
performs.

(For completeness: the chown path in fs/open.c does set ATTR_KILL_SUID
unconditionally for non-directories, but that is the standard POSIX
chown semantic of stripping setuid/setgid on ownership change -
independent of CAP_FSETID - and is outside the scope of this write-path
fix.)

Best regards,
Jiangshan Yi
