Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F82231C91
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 19:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764100547; cv=none; b=GWqnEGlwcvmXN/YsYu7wM+PWy0rktudTZIAa2rjMy5nDcwxvZbxwJVOc9c2QIgjI/ctnK5vKawaMxuUd+Pwdgf3JNW39/M9CnaB0EAGZrvdSxR7k6ZxK65UB6OcNKHF1P47zK4smefDRXm9cngh5sc7HsdpPP3FTHV+BsXqK9iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764100547; c=relaxed/simple;
	bh=aZJOpJ4exaCEYpzVdS/BO9sAM83usp/0BTcpwYCRN5k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bLnjYNKCDjfTJON1TUZzw0RXF4x7APoYAgOTZgvb7RdTinl1dxuMI5VT4uyTK9PLSz7h2q1EE/uKp04igzXYUgaWyub5guIGxBeTq+l2x9hkpy1J3BQtCCYxzLdfHE/rDr+PwFDswNaHSMvjmEsjI43b1A6YCeNmAlV63NG37No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=8C6VXYxX; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="8C6VXYxX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=EakBaGGuN6B6pNk/sVpSysdTuXgzGBFwZ36OyAjhZGc=; b=8C6VXYxXi/TrEd5fEcrooP7uAv
	hmPSfy+a1aBQs3BtieSSW1ugfS9CF0l3AF37MvWk7cVN7haAzz8/YGh3+IEpWpq7Y6QCq7EgQ0jEj
	FOzJAeq3izwW4TLDCe9K9JoQ/6wwVmhwUZKbJB31Mi/FpbDV+EwXl70qpH6u/54n3y3jHYvFoSkoZ
	3TZrvM7eagxWjo8UAlm7f75HDLUcH1jSNUwM/nScKBsAaSbqI88k4CDn51JZB3+EsQOdtmYpSLcpq
	QKO3DVQstR47FzOGY0ZC2Li9Mjcbf4wRbGPnGXXIY3L9jg/s/Q3WqGG2mrRp102IaVJRntXR89Kb+
	pDjEbGfA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1vNz8W-00000000Uvi-1yMq;
	Tue, 25 Nov 2025 16:55:41 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: piastryyy@gmail.com
Cc: Xiaoli Feng <xifeng@redhat.com>,
	Jay Shin <jaeshin@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <smfrench@gmail.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH] cifscreds: fix parsing of commands and parameters
Date: Tue, 25 Nov 2025 16:55:41 -0300
Message-ID: <20251125195541.1701938-1-pc@manguebit.org>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix the parsing of '--username' and '--timeout' options as both
require an argument by fixing the value passed in @optstring when
calling getopt_long(3).

Also fix the matching of commands by breaking the loop when an exact
match is found.  Otherwise `cifscreds clear ...` would return
"Ambiguous command" due to "clearall" command.

* Before patch

$ ./cifscreds add -u testuser w22-root2.zelda.test
error: Could not resolve address for testuser
$ ./cifscreds add -u testuser -d ZELDA
Password:
$ grep 'cifs:[ad]' /proc/keys
198de7a1 I--Q---     1 perm 0d0d0000     0     0 logon     cifs:d:testuser: 13
                                                                  ^^ wrong desc
$ ./cifscreds clear -u testuser w22-root2.zelda.test
Ambiguous command
$ ./cifscreds clear -u testuser -d ZELDA
Ambiguous command

* After patch

$ ./cifscreds add -u testuser w22-root2.zelda.test
Password:
$ ./cifscreds add -u testuser -d ZELDA
Password:
$ grep 'cifs:[ad]' /proc/keys
089183a9 I--Q---     1 perm 0d0d0000     0     0 logon     cifs:a:192.168.124.32: 17
0ca5ed80 I--Q---     1 perm 0d0d0000     0     0 logon     cifs:d:ZELDA: 17
$ ./cifscreds clear -u testuser w22-root2.zelda.test
$ ./cifscreds clear -u testuser -d ZELDA

Reported-by: Xiaoli Feng <xifeng@redhat.com>
Reported-by: Jay Shin <jaeshin@redhat.com>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Cc: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org
---
 cifscreds.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/cifscreds.c b/cifscreds.c
index 295059f9683d..e8713be23d71 100644
--- a/cifscreds.c
+++ b/cifscreds.c
@@ -71,7 +71,7 @@ static struct command commands[] = {
 static struct option longopts[] = {
 	{"username", 1, NULL, 'u'},
 	{"domain", 0, NULL, 'd' },
-	{"timeout", 0, NULL, 't' },
+	{"timeout", 1, NULL, 't' },
 	{NULL, 0, NULL, 0}
 };
 
@@ -477,7 +477,7 @@ int main(int argc, char **argv)
 	if (argc == 1)
 		return usage();
 
-	while((n = getopt_long(argc, argv, "dut:", longopts, NULL)) != -1) {
+	while((n = getopt_long(argc, argv, "du:t:", longopts, NULL)) != -1) {
 		switch (n) {
 		case 'd':
 			arg.keytype = (char) n;
@@ -507,7 +507,7 @@ int main(int argc, char **argv)
 		if (cmd->name[n] == 0) {
 			/* exact match */
 			best = cmd;
-			continue;
+			break;
 		}
 
 		/* partial match */
-- 
2.51.1

