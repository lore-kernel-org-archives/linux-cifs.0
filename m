Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7D83E9F81
	for <linux-cifs@vger.kernel.org>; Thu,  2 Apr 2026 14:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775139615; cv=none; b=Unu6nUrl8rSdRXUdmrJp05WtFJXLAdnQeOtLP2s2Hc3wL3aXY2JqQG6K/k6Nw8mfWf/ciGc67aVsvkOCyckhjtcT5GifRoYsqVHKev57j81w2KgyxR30DEdqyXOzdTEvPS/frT7GKnL3ZNLrbaWS3SnV7YHB0BiOWUPGk0SO4Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775139615; c=relaxed/simple;
	bh=rHruvPYPhyg30ALkqklA+DiuLv3EFXDqy7aHlZz0hkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BSe8FVAweY2ETeRXIVZ36KEDc41UTBlB3WH1R4z8NfJ1DyYn2pLB4opF5hSTeisFPuzRycZuLG45bpOHcX67jqnSQV9qsumy26JO9lcOYb3mdnVFxJpTSUWCECJ03V0gUkMO4VqOhNfDNuIWihEvmr+/9HeadvVMzo9JiMxxvgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PiGBChMF; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PiGBChMF"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775139610;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f/EEHcw2uOTHs8rFwYOK5k29+WmC+X7l+Y2Z5RmqpWQ=;
	b=PiGBChMFAvbOwvcdFTqUovVwdXzpERO6O8fozjCFQxaVKr48izT6wyHqAjfgH8Q9OKG695
	41+AZzWvpA8Ccon+yzss3UbrvTDyI4s5N/TRpDHr0X7vpV96SWQSfEy4hJDv+AR4ZEH4xn
	MTiOuemh6w2G6sqWgkEQyYj0eSIFDOk=
From: huiwen.he@linux.dev
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	dhowells@redhat.com,
	chenxiaosong@kylinos.cn,
	chenxiaosong@chenxiaosong.com,
	tangyouling@kylinos.cn
Cc: linux-cifs@vger.kernel.org,
	Huiwen He <hehuiwen@kylinos.cn>
Subject: [PATCH v3 10/13] smb/client: autogenerate SMB1 DOS/SRV to POSIX error mapping
Date: Thu,  2 Apr 2026 14:18:36 +0000
Message-ID: <20260402141839.461257-11-huiwen.he@linux.dev>
In-Reply-To: <20260402141839.461257-1-huiwen.he@linux.dev>
References: <20260402141839.461257-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

Extend the `gen_smb1_mapping` script to support generating sorted POSIX
error mapping tables for both ERRDOS and ERRSRV classes at compile time.

The script parses annotations from smberr.h to generate smb1_err_dos_map.c
and smb1_err_srv_map.c, which are included as the contents of the arrays
mapping_table_ERRDOS[] and mapping_table_ERRSRV[], respectively.

This ensures that the mapping logic remains synchronized with the source
headers and prepares for faster error lookups using binary search in the
future.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/.gitignore       |  2 +
 fs/smb/client/Makefile         |  9 +++-
 fs/smb/client/gen_smb1_mapping | 29 +++++++++++-
 fs/smb/client/smb1maperror.c   | 85 ++++------------------------------
 fs/smb/client/smberr.h         | 12 ++++-
 5 files changed, 57 insertions(+), 80 deletions(-)

diff --git a/fs/smb/client/.gitignore b/fs/smb/client/.gitignore
index d5ea5ac6015d..66e6e2ade0bd 100644
--- a/fs/smb/client/.gitignore
+++ b/fs/smb/client/.gitignore
@@ -1,2 +1,4 @@
 smb1_mapping_table.c
+smb1_err_dos_map.c
+smb1_err_srv_map.c
 smb2_mapping_table.c
diff --git a/fs/smb/client/Makefile b/fs/smb/client/Makefile
index 220a97c8a488..6e83b5204699 100644
--- a/fs/smb/client/Makefile
+++ b/fs/smb/client/Makefile
@@ -46,13 +46,18 @@ cifs-$(CONFIG_CIFS_COMPRESSION) += compress.o compress/lz77.o
 
 ifneq ($(CONFIG_CIFS_ALLOW_INSECURE_LEGACY),)
 #
-# Build the SMB1 error mapping tables from nterr.h
+# Build the SMB1 error mapping tables from nterr.h and smberr.h
 #
-smb1-gen-y := smb1_mapping_table.c
+smb1-gen-y := smb1_mapping_table.c \
+	      smb1_err_dos_map.c \
+	      smb1_err_srv_map.c
 
 $(obj)/smb1_mapping_table.c: $(src)/nterr.h $(src)/gen_smb1_mapping FORCE
 	$(call if_changed,gen_smb1_mapping)
 
+$(obj)/smb1_err_%.c: $(src)/smberr.h $(src)/gen_smb1_mapping FORCE
+	$(call if_changed,gen_smb1_mapping)
+
 $(obj)/smb1maperror.o: $(addprefix $(obj)/, $(smb1-gen-y))
 
 quiet_cmd_gen_smb1_mapping = GEN     $@
diff --git a/fs/smb/client/gen_smb1_mapping b/fs/smb/client/gen_smb1_mapping
index b2439fc09fe9..ef07c766e191 100644
--- a/fs/smb/client/gen_smb1_mapping
+++ b/fs/smb/client/gen_smb1_mapping
@@ -22,6 +22,7 @@ my $output_name = (split m|/|, $out_file)[-1];
 my $script_name = (split m|/|, $0)[-1];
 my @list     = ();
 my %seen     = ();
+my $current_class = "";
 
 # Parse annotated entries from the input file
 open(my $in, "<", $in_file) or die "Cannot open $in_file: $!";
@@ -46,6 +47,20 @@ if ($in_file =~ /nterr\.h$/) {
 			push @list, { val => $val, name => $name, class => $class, code => $code };
 		}
 	}
+} elsif ($in_file =~ /smberr\.h$/) {
+	while (<$in>) {
+		# Detect current error class from header comments (ERRDOS or ERRSRV)
+		if (/generated with the (\w+) error class/) {
+			$current_class = $1;
+		}
+
+		# Match #define ERR... or Err... <value> // -POSIX_ERR
+		if (/^\s*#define\s+((?:ERR|Err)[A-Za-z0-9_]+)\s+([0-9a-fA-FxX]+)\s*\/\/\s*(-[A-Z0-9_]+)/) {
+			my ($name, $val_str, $error) = ($1, $2, $3);
+			my $val = ($val_str =~ /^0x/i) ? hex($val_str) : $val_str;
+			push @list, { val => $val, name => $name, error => $error, class => $current_class };
+		}
+	}
 }
 close($in);
 
@@ -60,7 +75,7 @@ open(my $out, ">", $out_file) or die "Cannot open $out_file: $!";
 print $out "/* Autogenerated from $input_name by $script_name */\n\n";
 
 if ($output_name eq "smb1_mapping_table.c") {
-	# Generate NT status -> DOS error mapping file smb1_mapping_table.c
+	# Generate NT status -> DOS error mapping file
 
 	my $count = scalar @list;
 	my $full_names = "";
@@ -81,5 +96,17 @@ if ($output_name eq "smb1_mapping_table.c") {
 
 		$full_names = "";
 	}
+} elsif ($output_name eq "smb1_err_dos_map.c" || $output_name eq "smb1_err_srv_map.c") {
+	# Generate SMB1 error -> POSIX error mapping file
+
+	# Filtered by exact output filename
+	my $filter = ($output_name eq "smb1_err_dos_map.c") ? "ERRDOS" : "ERRSRV";
+	foreach my $e (@list) {
+		if (!$filter || $e->{class} eq $filter) {
+			printf $out "\t{%s, %s},\n", $e->{name}, $e->{error};
+		}
+	}
+} else {
+	die "Error: Unsupported output target: $output_name\n";
 }
 close($out);
diff --git a/fs/smb/client/smb1maperror.c b/fs/smb/client/smb1maperror.c
index 419057f296a7..294ac9646bff 100644
--- a/fs/smb/client/smb1maperror.c
+++ b/fs/smb/client/smb1maperror.c
@@ -21,85 +21,20 @@ struct smb_to_posix_error {
 };
 
 static const struct smb_to_posix_error mapping_table_ERRDOS[] = {
-	{ERRbadfunc, -EINVAL},
-	{ERRbadfile, -ENOENT},
-	{ERRbadpath, -ENOTDIR},
-	{ERRnofids, -EMFILE},
-	{ERRnoaccess, -EACCES},
-	{ERRbadfid, -EBADF},
-	{ERRbadmcb, -EIO},
-	{ERRnomem, -EREMOTEIO},
-	{ERRbadmem, -EFAULT},
-	{ERRbadenv, -EFAULT},
-	{ERRbadformat, -EINVAL},
-	{ERRbadaccess, -EACCES},
-	{ERRbaddata, -EIO},
-	{ERRbaddrive, -ENXIO},
-	{ERRremcd, -EACCES},
-	{ERRdiffdevice, -EXDEV},
-	{ERRnofiles, -ENOENT},
-	{ERRwriteprot, -EROFS},
-	{ERRbadshare, -EBUSY},
-	{ERRlock, -EACCES},
-	{ERRunsup, -EINVAL},
-	{ERRnosuchshare, -ENXIO},
-	{ERRfilexists, -EEXIST},
-	{ERRinvparm, -EINVAL},
-	{ERRdiskfull, -ENOSPC},
-	{ERRinvname, -ENOENT},
-	{ERRunknownlevel, -EOPNOTSUPP},
-	{ERRdirnotempty, -ENOTEMPTY},
-	{ERRnotlocked, -ENOLCK},
-	{ERRcancelviolation, -ENOLCK},
-	{ERRalreadyexists, -EEXIST},
-	{ERRmoredata, -EOVERFLOW},
-	{ERReasnotsupported, -EOPNOTSUPP},
-	{ErrQuota, -EDQUOT},
-	{ErrNotALink, -ENOLINK},
-	{ERRnetlogonNotStarted, -ENOPROTOOPT},
-	{ERRsymlink, -EOPNOTSUPP},
-	{ErrTooManyLinks, -EMLINK},
+/*
+ * Automatically generated by the `gen_smb1_mapping` script,
+ * sorted by DOS error code (ascending).
+ */
+#include "smb1_err_dos_map.c"
 	{0, 0}
 };
 
 static const struct smb_to_posix_error mapping_table_ERRSRV[] = {
-	{ERRerror, -EIO},
-	{ERRbadpw, -EACCES},  /* was EPERM */
-	{ERRbadtype, -EREMOTE},
-	{ERRaccess, -EACCES},
-	{ERRinvtid, -ENXIO},
-	{ERRinvnetname, -ENXIO},
-	{ERRinvdevice, -ENXIO},
-	{ERRqfull, -ENOSPC},
-	{ERRqtoobig, -ENOSPC},
-	{ERRqeof, -EIO},
-	{ERRinvpfid, -EBADF},
-	{ERRsmbcmd, -EBADRQC},
-	{ERRsrverror, -EIO},
-	{ERRbadBID, -EIO},
-	{ERRfilespecs, -EINVAL},
-	{ERRbadLink, -EIO},
-	{ERRbadpermits, -EINVAL},
-	{ERRbadPID, -ESRCH},
-	{ERRsetattrmode, -EINVAL},
-	{ERRpaused, -EHOSTDOWN},
-	{ERRmsgoff, -EHOSTDOWN},
-	{ERRnoroom, -ENOSPC},
-	{ERRrmuns, -EUSERS},
-	{ERRtimeout, -ETIME},
-	{ERRnoresource, -EREMOTEIO},
-	{ERRtoomanyuids, -EUSERS},
-	{ERRbaduid, -EACCES},
-	{ERRusempx, -EIO},
-	{ERRusestd, -EIO},
-	{ERR_NOTIFY_ENUM_DIR, -ENOBUFS},
-	{ERRnoSuchUser, -EACCES},
-	{ERRaccountexpired, -EKEYEXPIRED},
-	{ERRbadclient, -EACCES},
-	{ERRbadLogonTime, -EACCES},
-	{ERRpasswordExpired, -EKEYEXPIRED},
-
-	{ERRnosupport, -EINVAL},
+/*
+ * Automatically generated by the `gen_smb1_mapping` script,
+ * sorted by SRV error code (ascending).
+ */
+#include "smb1_err_srv_map.c"
 	{0, 0}
 };
 
diff --git a/fs/smb/client/smberr.h b/fs/smb/client/smberr.h
index d3633623473a..4ec2c5ffae25 100644
--- a/fs/smb/client/smberr.h
+++ b/fs/smb/client/smberr.h
@@ -24,7 +24,11 @@
 
 /*#define SUCCESS	0	The request was successful. */
 
-/* The following error codes may be generated with the ERRDOS error class.*/
+/*
+ * The following error codes may be generated with the ERRDOS error class.
+ * The comment at the end of each definition indicates the POSIX error
+ * code; it is used to generate the `mapping_table_ERRDOS` array.
+ */
 
 /*
  * Invalid function. The server did not
@@ -162,7 +166,11 @@
 #define ERRsymlink              0xFFFD	// -EOPNOTSUPP
 #define ErrTooManyLinks         0xFFFE	// -EMLINK
 
-/* Following error codes may be generated with the ERRSRV error class.*/
+/*
+ * The following error codes may be generated with the ERRSRV error class.
+ * The comment at the end of each definition indicates the POSIX error
+ * code; it is used to generate the `mapping_table_ERRSRV` array.
+ */
 
 /*
  * Non-specific error code. It is
-- 
2.53.0

