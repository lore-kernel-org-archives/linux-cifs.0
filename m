From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] [SMB3] File names with trailing period or space need special case conversion
Date: Thu, 23 Jun 2016 23:33:45 -0500
Message-ID: <1466742825-9867-1-git-send-email-smfrench@gmail.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

POSIX allows files with trailing spaces or a trailing period but
SMB3 does not, so convert these using the normal Services For Mac
mapping as we do for other reserved characters such as
	: < > | ? *
This is similar to what Macs do for the same problem over SMB3.

CC: Stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Signed-off-by: Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
---
 fs/cifs/cifs_unicode.c | 33 +++++++++++++++++++++++++++++----
 fs/cifs/cifs_unicode.h |  2 ++
 2 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index 5a53ac6..02b071bf 100644
--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -101,6 +101,12 @@ convert_sfm_char(const __u16 src_char, char *target)
 	case SFM_SLASH:
 		*target = '\\';
 		break;
+	case SFM_SPACE:
+		*target = ' ';
+		break;
+	case SFM_PERIOD:
+		*target = '.';
+		break;
 	default:
 		return false;
 	}
@@ -404,7 +410,7 @@ static __le16 convert_to_sfu_char(char src_char)
 	return dest_char;
 }
 
-static __le16 convert_to_sfm_char(char src_char)
+static __le16 convert_to_sfm_char(char src_char, bool end_of_string)
 {
 	__le16 dest_char;
 
@@ -427,6 +433,18 @@ static __le16 convert_to_sfm_char(char src_char)
 	case '|':
 		dest_char = cpu_to_le16(SFM_PIPE);
 		break;
+	case '.':
+		if (end_of_string)
+			dest_char = cpu_to_le16(SFM_PERIOD);
+		else
+			dest_char = 0;
+		break;
+	case ' ':
+		if (end_of_string)
+			dest_char = cpu_to_le16(SFM_SPACE);
+		else
+			dest_char = 0;
+		break;
 	default:
 		dest_char = 0;
 	}
@@ -469,9 +487,16 @@ cifsConvertToUTF16(__le16 *target, const char *source, int srclen,
 		/* see if we must remap this char */
 		if (map_chars == SFU_MAP_UNI_RSVD)
 			dst_char = convert_to_sfu_char(src_char);
-		else if (map_chars == SFM_MAP_UNI_RSVD)
-			dst_char = convert_to_sfm_char(src_char);
-		else
+		else if (map_chars == SFM_MAP_UNI_RSVD) {
+			bool end_of_string;
+
+			if (i == srclen - 1)
+				end_of_string = true;
+			else
+				end_of_string = false;
+
+			dst_char = convert_to_sfm_char(src_char, end_of_string);
+		} else
 			dst_char = 0;
 		/*
 		 * FIXME: We can not handle remapping backslash (UNI_SLASH)
diff --git a/fs/cifs/cifs_unicode.h b/fs/cifs/cifs_unicode.h
index bdc52cb..479bc0a 100644
--- a/fs/cifs/cifs_unicode.h
+++ b/fs/cifs/cifs_unicode.h
@@ -64,6 +64,8 @@
 #define SFM_LESSTHAN    ((__u16) 0xF023)
 #define SFM_PIPE        ((__u16) 0xF027)
 #define SFM_SLASH       ((__u16) 0xF026)
+#define SFM_PERIOD	((__u16) 0xF028)
+#define SFM_SPACE	((__u16) 0xF029)
 
 /*
  * Mapping mechanism to use when one of the seven reserved characters is
-- 
1.9.1
