Return-Path: <SRS0=z3C/=C6=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C733C43463
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Sep 2020 09:57:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71DAB21D7A
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Sep 2020 09:57:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbgIUJ5K (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 21 Sep 2020 05:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbgIUJ5K (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 21 Sep 2020 05:57:10 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B73C061755
        for <linux-cifs@vger.kernel.org>; Mon, 21 Sep 2020 02:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=RwzJ9I5iEqu1eKP5f4NqNFdt7v+JuhBAa8SQrKw8sLA=; b=ppJLt6cWxc/RpxXJp/KH2ds0yW
        4HTu3PY6/LeGtj83+MW4WniYE5TLW+xjwYBM1XVxe9ei8gWTjH+DN6Cd9CxnmaiCQ1JFc4kGd8rpu
        PB9bwEC3uhgONoDF+MDEbXQmbHPdi5Bgzo+Yxntgce9Nq3l0QNNt6mRtfphSzmvEp4mkii0dej3hG
        ofLhbE5iarHhvp0L+9vQWPboaya986OjGv1FZf3KNv7s9g9exT921eFQ+1YaftlnO4iTE1bRDxEB1
        bTmxo+3EI7tzKOtgi8iow57bwhdzPQSwDwR7wPBls5RRUPBl5L1o03GUmcrbzjbejn+ZV++zpsvYG
        ysc3o7WISLFYcZbJj47Ilz1dvgNJ5GukqnBx0Z/yeLhxLw2RNmtoNa1TGUx5F6R5pAwpxg4GM4PAQ
        SIePmwDBh0GyHM3kLLDwI1fZnizvc3l0olOxa/p6uq6s2svufnix9Tb5THe8lVTKUD9+oUdmswMe5
        jks0nSvst3dwEE4lFtglcJbt;
Received: from [2a01:4f8:192:486::6:0] (port=18328 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1kKIZF-0003OH-IT
        for cifs-qa@samba.org; Mon, 21 Sep 2020 09:57:05 +0000
Received: from [::1] (port=31006 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1kKIZF-002uhW-4T
        for cifs-qa@samba.org; Mon, 21 Sep 2020 09:57:05 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14506] New: cifs mount with missing krb5 key should give better
 error message
Date:   Mon, 21 Sep 2020 09:57:04 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: user space tools
X-Bugzilla-Version: 5.x
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bjacke@samba.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: jlayton@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 qa_contact target_milestone
Message-ID: <bug-14506-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D14506

            Bug ID: 14506
           Summary: cifs mount with missing krb5 key should give better
                    error message
           Product: CifsVFS
           Version: 5.x
          Hardware: All
                OS: All
            Status: NEW
          Severity: normal
          Priority: P5
         Component: user space tools
          Assignee: jlayton@samba.org
          Reporter: bjacke@samba.org
        QA Contact: cifs-qa@samba.org
  Target Milestone: ---

when trying to mount a cifs share with sec=3Dkrb5 but with missing krb5 key=
, then
the mount command returns:

mount error(2): No such file or directory

This error message does not really help most of the users, I think.

If there is a sec=3Dkrb5 cifs mount with an *expired* key and you try to ac=
cess
the mount point, the error message is better:

ls: =C3=96ffnen von Verzeichnis '.' nicht m=C3=B6glich: Der notwendige Schl=
=C3=BCssel ist
nicht verf=C3=BCgbar

(in English like "opening directory "." not possible: the required key is n=
ot
availbale").=20

A similar message would be good at mount time if the required key is not
available.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
