From: Joseph Salisbury <joseph.salisbury@canonical.com>
Subject: [v3.2.y][PATCH 0/1] cifs: set MAY_SIGN when sec=krb5
Date: Fri, 28 Feb 2014 16:07:34 -0500
Message-ID: <cover.1393535604.git.joseph.salisbury@canonical.com>
Cc: sfrench@samba.org, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
To: ben@decadent.org.uk
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

BugLink: http://bugs.launchpad.net/bugs/1285723

Hi Ben,

Please consider including a backport of upstream commit 0b7bc84000d71f3647ca33ab1bf5bd928535c846 in the next v3.2.y release.  It was included upstream as of v3.9-rc1.  It has been tested and confirmed to resolve http://bugs.launchpad.net/bugs/1285723 .

commit 0b7bc84000d71f3647ca33ab1bf5bd928535c846
Author: Martijn de Gouw <martijn.de.gouw@prodrive.nl>
Date:   Wed Oct 24 11:45:46 2012 +0200

    cifs: set MAY_SIGN when sec=krb5

This commit has a requrement for commit 8830d7e07a5e38bc47650a7554b7c1cfd49902bf, so it does not apply cleanly to v3.2.  I performed a backport to avoid this requirement, which is in email 1/1.


Sincerely,
Joseph Salisbury

Joseph Salisbury (1):
  cifs: set MAY_SIGN when sec=krb5

 fs/cifs/connect.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
1.7.9.5
