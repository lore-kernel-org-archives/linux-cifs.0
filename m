Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A38288D6
	for <linux-cifs@vger.kernel.org>; Sat, 10 May 2025 16:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746893778; cv=none; b=VD71OcaLEUNLgwtBLxXjnK6zerqWjyJQjgWFrEF4qE3ZULD5jmyNr6vCWwkR3GxVkE8giaPh+UAoZiYrcuF0HYvg4iRT5Va8Iics/P+Dd5YjMGRvZABSljpS1ytldurbisttfpz8JzZWRUDs1+L6ZLtMvRMPv+IrQkpy8UAckrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746893778; c=relaxed/simple;
	bh=wpmszWqFlEhxzGoghf3u0O+zQvjppOM4m4vLyyXCXpQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=kJbfda8seKWZ4ZAOgwAmPqheKHxQIidiV08+vPUE/4QP18sH/hlKiNhOVSEdSp/tVT6IhMkUcQ3hKgD4rxgWU9N0gOz9PHNJbviADswwGHb2cbDQG8IYYFo0sRDsT7mtw9UKvgP4GQKni/KWjQYNW454XYYETmSIgdJfsQkxNI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jDKwOGkI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jDKwOGkI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746893774;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=OL40eHnOLYcHfzwdcHnzo25+6/8t+DWLkV735Eq4z6Q=;
	b=jDKwOGkI8g3Ek1L2Ct2cEwCpqFBL59bfJnRZe8gy7RGUVb04Hyor3x54TGfYR4YeRXvBHx
	cE0hBCsrUX1P2fmC/P2ySmcEoaxsNoAM/7fiNNNfWA9JgmeFLA19qFNkGAIkkeeel+SpRQ
	Ak4Grwd+bvTYQ9m/Zx+F9EbcqfFxRbU=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-202-ZjoQdLBUOMuwPIchMewqnA-1; Sat, 10 May 2025 12:16:13 -0400
X-MC-Unique: ZjoQdLBUOMuwPIchMewqnA-1
X-Mimecast-MFC-AGG-ID: ZjoQdLBUOMuwPIchMewqnA_1746893773
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4767e6b4596so55565751cf.2
        for <linux-cifs@vger.kernel.org>; Sat, 10 May 2025 09:16:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746893772; x=1747498572;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OL40eHnOLYcHfzwdcHnzo25+6/8t+DWLkV735Eq4z6Q=;
        b=unoj2DUkloWRjqFdsAIZWhxJWlg0ufPWCVeL1mSYQQkUEs/vmT1xdKkFfe21jp7OPe
         g4QvXB7AYpB4vXc5XVdpekbaG0Ir2S9HVeyQMg34Tdtc9KqHtEVuZVPCUdoFY2PyapoO
         dwwLTOjdymkmMhbaO2T2Dn0inZ3rv+xWpSO5ReYrXpIMvhu9GK8dcm0YB8njisd61yPj
         OU0yTl/mUbr1ShgEP/37THBZzXFJcDqKCXYImLXziKDghjOlJdk/CWeTszsirEFCSJme
         iECp6d5TfOmU8kGfoc6HD+oUOFjFe7apItLdjAt61VC8cV9ETOxExk8EHnTl5lqk10mL
         vw/A==
X-Gm-Message-State: AOJu0YxWbdL4rBW/5g6T7fVbubJBG7ACt1goLLjpVCxN5wwYOYI6J5X0
	77jBShi0D9OUidOE2Lx0Q2Ottk/H7E+GvYLt2OeJKyrzssqgLz1kUqz+FCMOTKypzErTrFpi+1q
	cpQbFBr6MjIeY14KfF1tRl8mt0726QDSjdQoH1ACa5YosVssZdVPjhzivkQgQuA3uPix9W94Ksp
	pHbyCfD7mHOwGs+JXrQj4PvBawREiI93lJ+BBQokId2xM=
X-Gm-Gg: ASbGnctnz1YJtwGl4lHE+2JbHGoW8r/taHYHkDmZXvUhJjmzIwn44OJZL6muTuKSx62
	hQWTg6JWqMgDzg1stmNoexuB6LXjTG9IRiCaxonjgzRtVyoVre9UPqbzVinURJwvN5BJ7X0ioW5
	uzu7blu7DluMAFQu8N2uVbczjdkGyZRZ7qlxsR6ucy7D14tRfsbd4KfcLe8Ae3Rzg3UqclU7KjV
	T0N/MGi9aQPXgP7CFb9gKk2N+knF/0dFlKcru5N56C1aYnHp0RyfRK8dfwVS6moPCxzIOeSTPCl
	zKzoJ9XEzFb1f/yVQWIH2QWp8rHuztE7E0eYbU/Fa/+7bj04TpatMABHyYushpFhzbEutgU=
X-Received: by 2002:a05:622a:2c6:b0:476:add4:d2b7 with SMTP id d75a77b69052e-4945280e3a6mr102407121cf.51.1746893772408;
        Sat, 10 May 2025 09:16:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE1lxQTCgBTmYLl0GhxDw7ashJrAc3q03Le8wsSvezjBqHXMyO1++x161GOmYNVaqB/8coAig==
X-Received: by 2002:a05:622a:2c6:b0:476:add4:d2b7 with SMTP id d75a77b69052e-4945280e3a6mr102406461cf.51.1746893771814;
        Sat, 10 May 2025 09:16:11 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4945248d051sm27002431cf.29.2025.05.10.09.16.11
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 May 2025 09:16:11 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Subject: [cifs-utils RFC PATCH 00/12] cifs.upcall helper script enabling complex key description matching
Date: Sat, 10 May 2025 11:15:57 -0500
Message-ID: <20250510161609.2615639-1-sorenson@redhat.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Background:
The request-key mechanism, used to execute upcalls, uses string matching
of lines in the conf file to determine which program it should run to
instantiate a key.  This can usually be done based solely on the
requested key type.

It also allows further selection of the executable and/or program arguments,
based on string matches of the description and callout information fields
of the upcall with lines of the request-key conf files.  Each field (key
type, key description, callout information) can also contain a single '*'
wildcard to be used when doing the string matches, and the string must
fully match in order to be selected.

When the kernel performs the upcall during a cifs mount in which kerberos
is involved, the 'cifs.spnego' key type is requested.  The key's
description contains a number of key=value pairs, providing information
such as the server's name and IP address, the username of the mount, and
uid under which to search for the kerberos credentials.

An example key description:
    ver=0x2;host=smbserver;ip4=192.168.122.11;sec=krb5;uid=0x0;creduid=0x0;user=user1;pid=0xbaf7d

request-key will attempt to match the key's description with the string
in the description field of the config file, and executes cifs.upcall
with the given arguments.  However, the default configuration simply
calls cifs.upcall for all 'cifs.spnego' key types, regardless of the key's
description, and no additional arguments (other than the key id) are given
to the upcall:

    create  cifs.spnego    * * /usr/sbin/cifs.upcall %k

Specifying the string more explicitly to match the key's description more
fully allows differentiation between servers, username, etc., and
cifs.upcall will then execute with arguments specific to that server or
user, such as (with catch-all for fallback to the default cifs.upcall
execution):

    create  cifs.spnego ver=0x2;host=smbserver;ip4=192.168.122.11;sec=krb5;uid=0x0;creduid=0x501;user=user1;* * /usr/sbin/cifs.upcall -K /etc/smbserver_user1.keytab %k
    create  cifs.spnego    * * /usr/sbin/cifs.upcall %k

Unfortunately, the key's description includes the pid of the requesting
process, so in order to match the description string in the config file
with the key's description, the '*' wildcard must be used to cover that
portion of the description string.  As a result, each description string in
the config file must fully specify all of the other fields.  This includes
cases where a server name may resolve to multiple IP addresses; each
combination must be individually specified.  For example:

    create  cifs.spnego    ver=0x2;host=smbserver;ip4=192.168.122.11;sec=krb5;uid=0x0;creduid=0x501;user=user1;* * /usr/sbin/cifs.upcall -K /etc/smbserver_user1.keytab %k
    create  cifs.spnego    ver=0x2;host=smbserver;ip4=192.168.122.12;sec=krb5;uid=0x0;creduid=0x501;user=user1;* * /usr/sbin/cifs.upcall -K /etc/smbserver_user1.keytab %k
    create  cifs.spnego    ver=0x2;host=smbserver;ip4=192.168.122.13;sec=krb5;uid=0x0;creduid=0x501;user=user1;* * /usr/sbin/cifs.upcall -K /etc/smbserver_user1.keytab %k

This is inflexible, and can quickly become unmanageable; the addition or
change of an IP address to a server hostname would require updating the
/etc/request-key.d/cifs.spnego.conf file on all clients, and adding a
second user & keytab would require replicating the lines, with just minor
variations:

    create  cifs.spnego    ver=0x2;host=smbserver;ip4=192.168.122.11;sec=krb5;uid=0x0;creduid=0x502;user=user2* * /usr/sbin/cifs.upcall -K /etc/smbserver_user2.keytab %k
    create  cifs.spnego    ver=0x2;host=smbserver;ip4=192.168.122.12;sec=krb5;uid=0x0;creduid=0x502;user=user2* * /usr/sbin/cifs.upcall -K /etc/smbserver_user2.keytab %k
    create  cifs.spnego    ver=0x2;host=smbserver;ip4=192.168.122.13;sec=krb5;uid=0x0;creduid=0x502;user=user2* * /usr/sbin/cifs.upcall -K /etc/smbserver_user2.keytab %k

In addition, enabling use of gssproxy for credential retrieval is done by setting an environment variable, rather than an argument to cifs.upcall, changing the execution of cifs.upcall:

    create  cifs.spnego    * * /usr/bin/env GSS_USE_PROXY=yes /usr/sbin/cifs.upcall %k


This script:
This helper script takes the place of cifs.upcall in the request-key.conf
file, and is called directly for all 'cifs.spnego' types.  It allows the
use of more complex matching criteria of the fields of the key description,
then executes the actual cifs.upcall with the appropriate arguments.

The matching is done by reading from the helper's config file
(/etc/cifs-upcall-helper.conf), where each line consists of a set of match
criteria and options to pass to cifs.upcall in the event of a match.

Each of the match criteria consists of a field name (parsed from the
fields of the key's description - 'host', 'user', 'creduid', etc.), a
comparison operator, and the value to compare, and multiple match criteria
may be specified (all of which must pass in order to be selected).

Comparison operators include string matching and regexes for string fields
(host and user), numeric comparisons (<, >, =, !=, etc.) for uid and
creduid, and various IPv4 comparisons (ip ranges, network/netmask,
network/prefix, etc.) (IPv6 still to be implemented).

When a match is made, the options list can specify flags to cifs.upcall;
a keytab or krb5.conf file to use, a keyword to set the GSS_USE_PROXY
environment variable, etc.  Several % macros are also available, expanding
to the values of the fields in the key's description.

For example, the following line can replace the 3 lines above which specify
the hostname 'smbserver' and 'user1' username, and give a keytab to use:

    host=smbserver,user=user1    keytab=/etc/smbserver_user1.keytab

or to cover multiple users, use %u macro for username:

    host=smbserver                 keytab=/etc/smbserver_%u.keytab

The helper script then sets the appropriate arguments (and/or environment
variables), and execs cifs.upcall.

In addition to matching, key descriptions, the config file is also used
to increase debugging (to syslog) and to set the default arguments for
future matches in the file:

    # set the default arguments to cifs.upcall for subsequent matches
    default                 use_proxy

    # increase helper's syslog verbosity to 'info' level or 'debug'
    #   level (from errors-only):
    verbosity               info
    verbosity               debug

Details of the implemented matching rules can be found in the README
file, and additional example config file lines are in
cifs-upcall-helper.conf.examples.


I welcome feedback on the helper script, as well as thoughts on its
inclusion in cifs-utils.


Frank Sorenson (12):
  contrib: add directory and documentation for cifs-upcall-helper
  upcall-helper: add a sample config file
  contrib: add cifs-upcall-helper script
  upcall-helper: obtain and parse key description, assigning fields to
    key_vars
  upcall-helper: open and read each line of the helper's config file
  upcall-helper: set upcall_opts on a match, or if 'default' is given
  upcall-helper: set log level from config file
  upcall-helper: build command-line and set environment variables for
    cifs.upcall
  upcall-helper: replace macros in upcall argument strings
  upcall-helper: add string comparison
  upcall-helper: add uid comparison
  upcall-helper: add IP address comparisons

 contrib/upcall-helper/README                  | 138 ++++++
 contrib/upcall-helper/cifs-upcall-helper      | 400 ++++++++++++++++++
 .../cifs-upcall-helper.conf.examples          |  66 +++
 3 files changed, 604 insertions(+)
 create mode 100644 contrib/upcall-helper/README
 create mode 100755 contrib/upcall-helper/cifs-upcall-helper
 create mode 100644 contrib/upcall-helper/cifs-upcall-helper.conf.examples

-- 
2.49.0

