Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC79918F2FC
	for <linux-cifs@vger.kernel.org>; Sat, 10 May 2025 16:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746893778; cv=none; b=low3l8HZChSCxvs6ZEkR51dWBFwmO7QmDhOM18VhcCYwx5Sc7mzLGdDZsTTpd7EWRdQanrg1qhsWzSOtP9NTjVBAtwc+oPdxo9FUJY4jmZ1YbVwsEm+A/vWw/49v84wN6GpzOXTJogNVDscijnJet50SjGoOKBPH85wPdQIylkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746893778; c=relaxed/simple;
	bh=vk+SNBMNhTmQv696IdBQEYUmkmM/vdjj9uC1RWno1Eo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cfvvftrHSjagufOi9B596HxH1xsuJ/r/vvBvfMB9UF45ga7Pt990zI3tSauo8Jj10t8j+aj0gT/3n+2di5yxK7bLLX303HQZAoOS3FWTAoOOxZU1je3hRQDjbybAWWLhnPgGxrBXOtHa+P4PR23zZkmuDn6SCbGJZIpZShYCEcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C3kxKePh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C3kxKePh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746893775;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V0X2wJiban/SiEdmWRBZg11+95lhT3YEboq9qiUd7wQ=;
	b=C3kxKePhTaWEPeuYOE0RzzXt7ZCQdLFdRa+oGmYPcRYHdxjju56aYdqRjddapyxG6rNWPp
	3pgC/propElYNRYj+2iRGVEXhaHisPaj5ti17NWDnKxGe8rz84mUAS04EvKHjh7pMlcZzs
	9hdZuA8aV6HYNTE/yq4/ivbMCHtjxGM=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-302-x5eg18zsPQG34SjEjWTmIA-1; Sat, 10 May 2025 12:16:14 -0400
X-MC-Unique: x5eg18zsPQG34SjEjWTmIA-1
X-Mimecast-MFC-AGG-ID: x5eg18zsPQG34SjEjWTmIA_1746893773
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4768f9fea35so77322051cf.2
        for <linux-cifs@vger.kernel.org>; Sat, 10 May 2025 09:16:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746893773; x=1747498573;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V0X2wJiban/SiEdmWRBZg11+95lhT3YEboq9qiUd7wQ=;
        b=Mpx+vkwpTzbxnvyBTcCSw8y/k/3W1CqDC+c03i6L0lA5kn3R4YncuqyNkyE6jGsWwN
         21Fe14xO28Br2cckLQ5nySAkWgeJnPsk27vHuGc06eNa74xuF2HSxVv/cfN26GCCKWXs
         x3A9089rlRogbWf+lamquh4s6r68PRNJuzk+1g/WF1kPo5JwuEdi5vCJYj0ddwWKMFZo
         VHxeIYeE1732wMGJoJSR/vsl3AiHMID+dmU8PXFhlFAEJttAm6b73nrhR1Zi5Zbxx3Hr
         cyxttFS+9lISp9e1DoLah19ebwU77CCoY3SLtb7TCMPpjGX0e1etSTRYrbikT8NNJKqH
         CSKA==
X-Gm-Message-State: AOJu0YzgAIHki/tzRPNGVMfM9FMOBg0vHmHfBRt0cBQ7xCf6CwnMSJwC
	XDJJB6X/5Xkj/UrSsuJtzLfB7cDMRg7PxfUA7d1/suM6GfRFDTlNHpclsQPg3gcWEYrxB0NIkQf
	3foDI42tlRbzXEm8IiYa3lUsloRU6MzfGTAluvl5IAFKD6emJno5mtWywxINPJpU4gm9qmsaagy
	OICW5IHbPMZb/zLQeoXGGiukCP0KuNM4oRbBgg5SWGd+w=
X-Gm-Gg: ASbGnctvfQQJSUVkpF+aLjYOfTOsHv+oG7FUsBPgoHxth4Zi8ZgoDDwnJhTPJt4MvyA
	WU5GqayLywyTVVj7FpvRqlZRVGBRdFt3O51J/ErCy8/zK1N35iYrSgAVmJnu3ZzDGjT00psuRdD
	xAqdBaqxun+ETlEzmv6huHadZRC6p5Mn3LuG+sQreRKl4tzeNrBa0cJqspWk2O6BLbB8gcnytY+
	R0X2o1v5m/ciXtywQa6R8erGmEtK2SfnWsbFJt4clTswtUz+q0w8kDqzGqSyYR4w4OKDp5oGSfR
	W9Uuq5hpZLG45YOE/c3+xirLJz/zuOlMl7ADrcEYCvqtsHTv7ZfhgCt2SGId+5Zliue9A/8=
X-Received: by 2002:ac8:5d45:0:b0:474:e75e:fccc with SMTP id d75a77b69052e-494527ba618mr129635121cf.35.1746893773173;
        Sat, 10 May 2025 09:16:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG9Tmjzztu4kZDkySBrCTLsn8a0yct5TSCEysGqoCNZ9zmpbVratE/lXma7VlDjv3Q7f6p97A==
X-Received: by 2002:ac8:5d45:0:b0:474:e75e:fccc with SMTP id d75a77b69052e-494527ba618mr129634591cf.35.1746893772553;
        Sat, 10 May 2025 09:16:12 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4945248d051sm27002431cf.29.2025.05.10.09.16.11
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 May 2025 09:16:12 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Subject: [cifs-utils RFC PATCH 01/12] contrib: add directory and documentation for cifs-upcall-helper
Date: Sat, 10 May 2025 11:15:58 -0500
Message-ID: <20250510161609.2615639-2-sorenson@redhat.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250510161609.2615639-1-sorenson@redhat.com>
References: <20250510161609.2615639-1-sorenson@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a directory in contrib for the cifs-upcall-helper script,
with README that explains the script's use.

Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 contrib/upcall-helper/README | 138 +++++++++++++++++++++++++++++++++++
 1 file changed, 138 insertions(+)
 create mode 100644 contrib/upcall-helper/README

diff --git a/contrib/upcall-helper/README b/contrib/upcall-helper/README
new file mode 100644
index 0000000..9f33cca
--- /dev/null
+++ b/contrib/upcall-helper/README
@@ -0,0 +1,138 @@
+This helper script is used in /etc/request-key.d/cifs.spnego.conf to
+  enable complex matching of fields in the description of the key
+  when using krb5 for cifs mounts; when a match is found, cifs.upcall
+  is then executed with the specified options.
+
+This script will read each line of /etc/cifs-upcall-helper.conf, applying
+  match criteria in the first field to the key description; if all
+  criteria match, the options specified in the second field are used to
+  construct the command-line for calling the cifs.upcall program.
+
+If the cifs-upcall-helper.conf file is not present, or if no lines match,
+  the cifs.upcall is executed with the current default options (if any)
+
+
+To use this helper script, install this script at
+  /usr/sbin/cifs-upcall-helper, and replace the following line in
+  /etc/request-key.d/cifs.spnego.conf:
+
+        create  cifs.spnego    * * /usr/bin/cifs.upcall %k
+
+    with
+
+        create  cifs.spnego    * * /usr/sbin/cifs-upcall-helper %k
+
+
+each line of the cifs-upcall-helper.conf file has the following format:
+
+    <line> :=
+        <selection_criteria><whitespace><options>
+        default<whitespace><options>
+        log_level<whitespace><log_level>
+
+    <selection_criteria> := <criterion>[<delimiter><criterion>]*
+
+    <options> := <option>[<delimiter><option>]*
+
+    <delimiter> := [,;]
+
+    <criterion> :=
+        *
+	host<string_comparator><host_string>
+        user<string_comparator><user_string>
+        sec<string_comparator><sec_string>
+
+        ip4<ip4_comparator><ip4_string>
+        ip6<string_comparator><ip6_string>
+            (TODO: enhance ip6_comparator)
+
+        uid<numeric_comparator><uid_string>
+        creduid<numeric_comparator><uid_string>
+
+    <string_comparator> :=
+        '=' | '==' | '!=' | '~' | '!~'
+            '=', '==', and '!=' compare as 'globs'
+                ('*' is a wildcard which represents zero or more
+                characters; all other characters are literals)
+            '~' and '!~' compare the string as a 'regex'
+
+    <host_string> := <character_string>
+    <user_string> := <character_string>
+    <sec_string> := krb5 | mskrb5 | iakerb
+
+    <character_string> := [-a-zA-Z0-9_.]
+
+    <ip4_comparator> := '=', '==', '!='
+
+    <ip4_string> :=
+        <ip4_addr> | <ip4_range> | <ip4_net_netmask> | <ip4_net_prefix>
+
+    <ip4_addr> := [0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}
+    <ip4_range> := <ip4_addr>-<ip4_addr>
+    <ip4_net_netmask> := <ip4_addr>/<ip4_addr>
+    <ip4_net_prefix> := <ip4_addr>/<ip4_prefix>
+    <ip4_prefix> := ([0-9]|[12][0-9]|3[0-2])
+
+        (invalid netmask/prefix results in 'not a match', regardless of comparator)
+
+
+    <numeric_comparator> := '<' | '<=' | '=' | '==' | '>=' | '>' | '!='
+
+    <uid_string> := [0-9]+ | 0x[0-9a-fA-F]+
+
+    <option> :=
+        * | -
+        keytab=<path>
+        krb5conf=<path>
+        krb5_trace=<path>
+        use-proxy|use_proxy
+        no-env-probe|no_env_probe
+        trust-dns|trust_dns
+        legacy-uid|legacy_uid
+
+    with the exception of use_proxy and krb5_trace, options are passed to 'cifs.upcall'
+        with the relevant command-line argument; see the OPTIONS section of the manpage
+        for cifs.upcall(8) for further details
+
+    use_proxy sets the GSS_USE_PROXY environment variable prior to calling 'cifs.upcall',
+        enabling the use of gssproxy; see the ENVIRONMENT VARIABLES section of the manpage
+        for cifs.upcall(8) for further details
+
+    specifying 'krb5_trace' with path will set the KRB5_TRACE environment variable to the
+        path, prior to calling 'cifs.upcall'; setting this environment variable causes
+        kerberos-related tracing to be written to the file; see the ENVIRONMENT VARIABLES
+        section of the manpage for kerberos(7) for further details
+
+
+    in the <option> field, the <path> values for <keytab>, <krb5conf>, and <krb5_trace>
+        will also accept the following macros:
+        %h   server hostname
+        %i   server IP address
+        %s   sec type
+        %U   uid
+        %c   creduid
+        %u   username
+
+
+    when 'default' is specified as the selection criteria, all currently-specified
+        default options are cleared, and the <options> specified (if any) are
+            set as defaults
+        the line does not match, and processing continues with the next line
+        use option '*' or '-' as a placeholder; options will be cleared, but no
+            new options set
+        NOTE: default must be the only criteria
+
+
+    <log_level> := (0|1|2|errors|info|debug)
+
+    when 'log_level' is specified as the selection criteria,
+        the logging level is set to the specified level.  Options are:
+            0|errors
+                only errors are logged to syslog, at level LOG_ERR
+            1|info
+                more verbose information is logged to syslog, at level LOG_INFO
+            2|debug
+                verbose debugging messages are output to syslog, at level LOG_INFO
+            any other values
+                verbosity is unchanged
+        NOTE: log_level must be the only criteria
-- 
2.49.0

