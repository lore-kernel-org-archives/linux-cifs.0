Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazolkn19013072.outbound.protection.outlook.com [52.103.51.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D45327BFC;
	Sun,  6 Sep 2026 23:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.51.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788737926; cv=fail; b=RT7Ef8KoC33+6IMA6zy5s1JdK3dlCJM47MwRX7sCJWqpsNQEAk4ewy7o8yFDXtp9io5rBG40bTyYQwKqzBh6AP08hjpMyYcz5YQIsfbhyjjyl7TmYZjnXuwQ46j74kmRpgKhmsJ4ZPiwlmA+eXX1wvGSaS0jXbknIk3vxXRrqXE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788737926; c=relaxed/simple;
	bh=IdVBnPTcmi3LLlLMtb0K97QKbiiF6C5wc873NgtJkQo=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=LZ1VM0MkKVyR1XC/dQSkOxtYJqupy8d0KgAM8V6eIm2vUalzW+JfY/6I/7Hw7vg3uIvLTayShtuxiANj+GYE4tIU/DxFO/XipPFQPnuUeyCgJW+0aeyh9tC2WwOEyyDHJgUzHeT06IIhEutiLjLGusmen0P69F3OBRitiEDlNH8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk; spf=pass smtp.mailfrom=hotmail.co.uk; dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b=bnN6XrZU; arc=fail smtp.client-ip=52.103.51.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b="bnN6XrZU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L9b4pwO3GzecDA4PhC24cUy9tEMAwXZCBM8IPxXHSYqHHoImE8mu7UVjPw5HW3PYpg5K/wZnyDjKBR4NU3zqvcD+pkxMqXaCR6OCcBtNn6UPX1jTsnOd3aY+2P8D1cqe+hPkH+UDoNaMezMZuYX1U8ZMc+PNA2FG7JBurdTPwmfowLJnP1yDuhUIetDSiV/Ez5PiN1WUYRbPTnuZqu/msyEGr59u3eBba5vXoBgTO6b7u3AimJWdV/7883GqFX8Q/yUnc5ZDU4Fapk5uwVAHnAf545YhWFEytNBshmyzd3pjxyUOd56oZnXgpJOXys7Ir4Rykk4K7fammQ2B9SDESQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NHbCgvvcSA5OotRixzmZBeXLQehxFcU7Gpi67OV1F3w=;
 b=ar8Wu/uWI8avrMOMp51P54kYVWwFNgUZq++1oR2ITOVVfAsgyPApdkpOtUDOID4rB9YYOQretrdfptLC3hT8KfJaatHmuo1GA8KkmadCS/3jTLz6DawVuD+e5AeHu21qy8qHkcpuXn6dyC0W3t0qS2fU1Nuk6jU/R8kQWQIw49saeTi73qPeh8yHq0qMdEzHuetstHBQhwM8CTibNqCH3plD/5aGavWPiG0WxC0Rz8EVCwpymLmNHp66fD1o43qo7ZpDu/sK3doLCPXj3/iCzTR97H1FVlt2bwHlcPhoznV2B4EExoBxv7F1JQBz5dLfKJ2gHEA9kLL3LSrvFVMnjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=HOTMAIL.CO.UK;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NHbCgvvcSA5OotRixzmZBeXLQehxFcU7Gpi67OV1F3w=;
 b=bnN6XrZUTRqb4sGdCRBmiBXzPiIzAbkQcOeEzf8+jY9ksDctbJy+rC9C35CJ5I3oEN/72Cfqf6F3ntD8iWmh17Ple88AUi3k/UFXuWAQT08dZHWFPO+4YMYalkvu6J/0l/+RaFuScIePpjqASWlkVsvsNjPFykh5/oCNPLxUjcGfHu1T8XQezXBbccQAoO/st+AQhXzqCUKaLPvEbHclwJjQuEKtIbHVnHqvA74SLkcmQRiuU51etDRAzkPLqVyK98UAblmtNPtdXJs7hopOiDfmKpnDHFg0CuqG0UhAmPd6nDasBMMElwYTD8RAqCDRYc7xPAdnXl54EnTOSPo3LA==
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:344::22)
 by PAXP251MB0113.EURP251.PROD.OUTLOOK.COM (2603:10a6:102:200::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Sun, 6 Sep
 2026 23:38:42 +0000
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352]) by AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352%6]) with mapi id 15.21.0382.014; Sun, 6 Sep 2026
 23:38:42 +0000
From: Aamir Ahmed <elb12345@hotmail.co.uk>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <sfrench@samba.org>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: initialise the reserved fields of six SMB2 responses
Date: Mon,  7 Sep 2026 00:38:38 +0100
Message-ID:
 <AS8P251MB000178EC4EE49C074687E8CBC8B32@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.53.0.windows.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0122.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:192::19) To AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:344::22)
X-Microsoft-Original-Message-ID:
 <20260906233838.87815-1-elb12345@hotmail.co.uk>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P251MB0001:EE_|PAXP251MB0113:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b73aca7-adf3-4a88-6e89-08df0c6ffbfb
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|24021099003|55001999006|16051099003|5062599005|5072599009|4140399003|15080799012|25010399006|23021999003|25031999004|37011999003|19110799012|8060799015|41001999006|12121999013|16041099003|440099028|3412199025|26104999009|53005399003|40105399003|2607281247196008;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wUqN98kIBpnmv2xkp8f9D4mVGtdnteru1AJU6qBmF1yS//PghtQrZ3IT3v7E?=
 =?us-ascii?Q?p8WPe6n9DajL/4iojXz+7WNQ+i1n/wSTV0cDRzztlCpwAwM7k7ZaqflISmGC?=
 =?us-ascii?Q?n8H2SQlMHFjOkP+EoKbtxGrIn9PjFkrpxsUlHs1xgl3a1/XL0acq1ek0wEuO?=
 =?us-ascii?Q?c9rKi+78Gux9n35J2ye17bjY7Ybvt0uYoZS3AV8ltTpKIcg2V0XeQ2osz8ow?=
 =?us-ascii?Q?6Hp9ZKS/wU/Wlj8rQJCJyqcDNdlSGnnxqoZhi94YkN9pL+1zuwo+KDG/PEhh?=
 =?us-ascii?Q?blX8OpUjzDLoGC8Ofl1atAPKG0ciQyjQq7qzEpu8ntE7f9KDFNYWLbPT9ANa?=
 =?us-ascii?Q?NJKi2rb/LdbKa6s84ufdkN43daQMoIVchTMXQaJUpTJkOBXKh/+ztWcBowfo?=
 =?us-ascii?Q?mNMTVhpAGrbm8KIWFezjsJaJx3wvVYwsntd3O0RZArv7Rua0vZ8DbfwdvPBl?=
 =?us-ascii?Q?Auq+xi6zesVHiFXholkcKRbM7qfu4FdiWS4SpkkG7FvX/EaDmQUE+Wly2V/S?=
 =?us-ascii?Q?ZqdF0aeJQo6Zhgg5NYm6OZOeobTqOybhJV0f7970z2YKmzX+uEOP0L6P1q/t?=
 =?us-ascii?Q?8m5w2Yry5vkO/t3sAtIepxJWh5q+/qxE+c6yUTRyW3vZT2TcK2Sby4s9T/fE?=
 =?us-ascii?Q?Ty9u5ligyyC7F5MciZi7XYO65E9CTLOCP/UFbdXriHzLQRQClrKaYAwYv6LM?=
 =?us-ascii?Q?j9Tq3MbhMBmSVSqeF1zxL1Wx2EHGq61T6rX5OauvBQBfryZ7dB5p5Dt1p2Mj?=
 =?us-ascii?Q?ARbbPfz18krYgZGvjL3H4GB/VnfP0uWLSThih3MaFs0YSH6A0LLd+NH9gV1A?=
 =?us-ascii?Q?steBVuA9jjlKAmN+k+Xtk8cPFGYEeT/NQv9p7vMhy1qh4H2v1VOY1qCTdVvd?=
 =?us-ascii?Q?qnlqjh05YFHdVErXwWRRGBVIpnt46JIRMuddbbiwnomR3RpmYMBlago/OOen?=
 =?us-ascii?Q?EoFMc5otbEB33fR6zSan8D2gRTvIR1gGRWmCBRbNchyMDoOavtTZWOzErJF6?=
 =?us-ascii?Q?+qm4d5+uZn6MdVi6u93V0wp1xTIjI4Y283HtcpyD2a9IqG9iIS/ng7EK5P/+?=
 =?us-ascii?Q?9HeVc7UGRWwRa/wZyKd5Pr0R0VDKCYaGatv4x4ZqA9x0YEKCdFkvGX996YnM?=
 =?us-ascii?Q?OJezEzJbqyf56S7UjNMjdYk7fRAWLUJQC9E5UI1dUxs6mZFVzgEkvH+KqZCS?=
 =?us-ascii?Q?uMEWuscscXLb4u8x?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oQiCV2UhdBXOqn6RQP/V1Ak4hQjtkTFVdjWuuf+i9+2L4koAVhuqsDGogr09?=
 =?us-ascii?Q?sowSMUWpIr6kcTzeXMub3gASYT4rZxlF5R46+PLjNkfXB5ujg0peXk5GbKUY?=
 =?us-ascii?Q?4eu5p0nDb1uC4MMeY1RNMctnPoBbz/I4dtCUg/FPgpDk6zZVYDp/S0inc+Cm?=
 =?us-ascii?Q?TFbW8ZF2IWCetzj6od05mHJdBLrskUUOYniXtsysvsAZyl8mSih7oPrcXA/9?=
 =?us-ascii?Q?2T9FYIc7Vsegz5yVuXVz86WZluYcQC1Gzz70IBgZDnRojadtlOBxjUFIooiv?=
 =?us-ascii?Q?4YehqR1rWTvIQRPWUC5afEvkaOmAPM8XFBjoxGmQOWAJNwX+brcYN0a+vV4k?=
 =?us-ascii?Q?jR1dL4pBLqMTbT4B7eYxdQW03nkeXS0AN9049D3i0UYf5hBSvzCnFl/5qFrk?=
 =?us-ascii?Q?cJ2NzfYL4a7s7AAo5Z9VlhM3xURd79uDxRCTJV795najDTz5lMV7p0oZr0DB?=
 =?us-ascii?Q?OaQ3IB4TGuhyenMUq8JjDqcNzLOE8cNOTJVHbXODKsIaDEHIwPG/Q/4sfjJy?=
 =?us-ascii?Q?t5+EB862PgLiK9xH3P1ZYnjoSXXQ1B04Q4Akt26pApaFfVsSKaDHspV31ENv?=
 =?us-ascii?Q?Wc2R56S7qBbQ/VV7FRa3Gr4modpxpLoMle2gHXQ84Imboir7rHvOvMgbhSIC?=
 =?us-ascii?Q?NaEe7cjs0R6pULu7ygEZ1xTngpKhBIn/LYXHcUL+BZTFCyGPggJDCHgBnO+i?=
 =?us-ascii?Q?KhYep+fi9xl4fUKZR5VW2CB2hGWUkli2agcesc9bcaXsvcB9w6rPLs+wAvVf?=
 =?us-ascii?Q?jl+Yg2t2SSSB7upjzosoVCReKsdLXUfewzI+WckPP0CWP3g//jzDL6HDuKWE?=
 =?us-ascii?Q?a3N9AKS0xKCprpP0A1BsqfD1LerfYRNTrm0DsZA3Xl/7na6+N4EFsd2YPU1y?=
 =?us-ascii?Q?rDVq+6yh5vbXhQb0Z8rer8JAC5vriO5HeVWP6QnEkdPa8QNkLf3FWs8Hnl9J?=
 =?us-ascii?Q?CjXbSYhjabyC7jt1K78ffzq63MYAhfplIn/vszmJO8dO0despwjub1AjJr4o?=
 =?us-ascii?Q?yhXo34EyR4x6euI815obgB4x52s6ascWXUfOmTcgEBR8DQMrznDqwqXyyVcv?=
 =?us-ascii?Q?cWR1a2x6kpm/SUbGEl++tHQ2cTRGQnK1l6zb6i014O35kZgTVpOQItnJ+8FI?=
 =?us-ascii?Q?mLtOqyMbwohkr6gIZenRmYu2EffQWm4eG7jrQAX57Ym5kXhPFA0XcGQqNEWw?=
 =?us-ascii?Q?vQtktrhpVfF9VMGGF+qz1MnTTnUVh7yhzUXfuwLv6fKUqLpeiQsNJWbEG7s6?=
 =?us-ascii?Q?r7hW9ApuHyo1GIzCmLh5f2Ow4Kxg+D8uyp8ddZ+X+9cVYC1NNhOgivp4JMux?=
 =?us-ascii?Q?wkdf06so5KCWUhlQhvLq9goZC1KrblfMlNO5V4HginFC/B1RErFriV3J2h7e?=
 =?us-ascii?Q?kx9TxQq8C+jyzkhT18D0o8/xyeEWDcQtMSxN/YVvCpBd6Eje3l5AZbkdiMaW?=
 =?us-ascii?Q?LxQFQdIH4eSx0F7G50gSTnFb9ooLk9GE?=
X-OriginatorOrg: sct-15-20-9412-3-msonline-outlook-fe3f5.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b73aca7-adf3-4a88-6e89-08df0c6ffbfb
X-MS-Exchange-CrossTenant-AuthSource: AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2026 23:38:42.0554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXP251MB0113

smb2_allocate_rsp_buf() zeroes the response buffer, so a standalone
request never leaks.  A compound request can: the offset of the next
response is advanced by the length pinned for the previous one, so a
reply that was written into the buffer and then dropped in favour of the
short error response of smb2_set_err_rsp() stays there, and the next
reply is laid over it clearing only

	memset(rsp_hdr, 0, sizeof(struct smb2_hdr) + 2);

which covers the header and StructureSize and stops before Reserved.

Six responses declare their full size but leave a field unwritten, so
those bytes reach the client as they are found in the buffer:

  - get_file_standard_info() and get_standard_info_pipe() never set
    smb2_file_standard_info.Reserved, 2 bytes at offset 22 of the 24
    they report.
  - find_file_posix_info() never sets smb311_posix_qinfo.Zero or
    .ReparseTag, 4 bytes each at offsets 64 and 72 of the 112 it
    reports.
  - smb2_session_logoff() and smb2_tree_disconnect() never set Reserved
    in their 4-byte bodies, which are pinned with a bare sizeof().
  - the FSCTL_GET_REPARSE_POINT case of smb2_ioctl() sets ReparseTag and
    ReparseDataLength but not reparse_data_buffer.Reserved, 2 bytes at
    offset 6 of the 8 it reports.

The logoff and tree disconnect cases are oversights rather than
convention: five responses share the layout { hdr; __le16 StructureSize;
__le16 Reserved; }, and smb2_echo(), smb2_flush() and smb2_lock() all
zero Reserved explicitly while those two do not.

This is the same class as the FS_OBJECT_ID_INFORMATION and
FS_CONTROL_INFORMATION leaks fixed in the series merged on 2026-08-31.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
---
Found with AI assistance (Claude Code) by extracting the class from the
four fixes merged 2026-08-31 and sweeping every response builder and
every ksmbd_iov_pin_rsp() site in fs/smb/server/ against the struct
definitions.

Observed on the wire.  An SMB2 QUERY_INFO for FileStandardInformation,
against a ksmbd built with the 24-byte reply poisoned with 0xAA before
the handler fills it, returns to the client:

  00100000 00000000  AllocationSize = 4096
  0c000000 00000000  EndOfFile      = 12
  01000000           NumberOfLinks  = 1
  00                 DeletePending  = 0
  00                 Directory      = 0
  aaaa               Reserved       = untouched poison

The same probe confirms find_file_posix_info() leaves both Zero and
ReparseTag at 0xaaaaaaaa (driven by a cifs mount with vers=3.1.1,posix,
which sends SMB_FIND_FILE_POSIX_INFO inside a compound request), and
smb2_tree_disconnect() leaves Reserved at 0xaaaa.

Struct offsets verified by compiling the layouts:
  smb2_file_standard_info  size 24, Reserved at 22
  smb311_posix_qinfo       size 80, Zero at 64, ReparseTag at 72
  reparse_data_buffer      size  8, Reserved at 6

Two candidates the sweep raised and I discarded: get_file_stream_info()
computes its length as sizeof() + streamlen * 2 rather than a bare
sizeof, and smb2_file_all_info.__pad is a union member sharing storage
with the flexible FileName array, which is written.  The
FSCTL_CREATE_OR_GET_OBJECT_ID reply looks similar but explicitly memsets
all four of its 16-byte IDs.

  fs/smb/server/smb2pdu.c | 7 +++++++
  1 file changed, 7 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index d656832d82efe..c9786732f00c4 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3052,6 +3052,7 @@ int smb2_tree_disconnect(struct ksmbd_work *work)
 	}
 
 	rsp->StructureSize = cpu_to_le16(4);
+	rsp->Reserved = 0;
 	err = ksmbd_iov_pin_rsp(work, rsp,
 				sizeof(struct smb2_tree_disconnect_rsp));
 	if (err) {
@@ -3140,6 +3141,7 @@ int smb2_session_logoff(struct ksmbd_work *work)
 		return err;
 
 	rsp->StructureSize = cpu_to_le16(4);
+	rsp->Reserved = 0;
 	err = ksmbd_iov_pin_rsp(work, rsp, sizeof(struct smb2_logoff_rsp));
 	if (err) {
 		rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
@@ -6301,6 +6303,7 @@ static void get_standard_info_pipe(struct smb2_query_info_rsp *rsp,
 	sinfo->NumberOfLinks = cpu_to_le32(1);
 	sinfo->DeletePending = 1;
 	sinfo->Directory = 0;
+	sinfo->Reserved = 0;
 	rsp->OutputBufferLength =
 		cpu_to_le32(sizeof(struct smb2_file_standard_info));
 }
@@ -6628,6 +6631,7 @@ static int get_file_standard_info(struct smb2_query_info_rsp *rsp,
 	sinfo->NumberOfLinks = cpu_to_le32(get_nlink(&stat) - delete_pending);
 	sinfo->DeletePending = delete_pending;
 	sinfo->Directory = S_ISDIR(stat.mode) ? 1 : 0;
+	sinfo->Reserved = 0;
 	rsp->OutputBufferLength =
 		cpu_to_le32(sizeof(struct smb2_file_standard_info));
 
@@ -7162,6 +7166,8 @@ static int find_file_posix_info(struct smb2_query_info_rsp *rsp,
 	}
 
 	file_info->DeviceId = cpu_to_le32(stat.rdev);
+	file_info->Zero = 0;
+	file_info->ReparseTag = 0;
 
 	/*
 	 * Sids(32) contain two sids(Domain sid(16), UNIX group sid(16)).
@@ -11288,6 +11294,7 @@ int smb2_ioctl(struct ksmbd_work *work)
 		reparse_ptr->ReparseTag =
 			smb2_get_reparse_tag_special_file(file_inode(fp->filp)->i_mode);
 		reparse_ptr->ReparseDataLength = 0;
+		reparse_ptr->Reserved = 0;
 		ksmbd_fd_put(work, fp);
 		nbytes = sizeof(struct reparse_data_buffer);
 		break;
