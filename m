From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 63/73] cifs: In Kconfig CONFIG_CIFS_POSIX needs depends on legacy (insecure cifs)
Date: Wed, 12 Dec 2018 23:28:28 -0500
Message-ID: <20181213042838.75160-63-sashal@kernel.org>
References: <20181213042838.75160-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20181213042838.75160-1-sashal@kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Steve French <stfrench@microsoft.com>

[ Upstream commit 6e785302dad32228819d8066e5376acd15d0e6ba ]

Missing a dependency.  Shouldn't show cifs posix extensions
in Kconfig if CONFIG_CIFS_ALLOW_INSECURE_DIALECTS (ie SMB1
protocol) is disabled.

Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index abcd78e332fe..85dadb93c992 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -133,7 +133,7 @@ config CIFS_XATTR
 
 config CIFS_POSIX
         bool "CIFS POSIX Extensions"
-        depends on CIFS_XATTR
+        depends on CIFS && CIFS_ALLOW_INSECURE_LEGACY && CIFS_XATTR
         help
           Enabling this option will cause the cifs client to attempt to
 	  negotiate a newer dialect with servers, such as Samba 3.0.5
-- 
2.19.1
