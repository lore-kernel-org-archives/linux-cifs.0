Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F411E3EC2FF;
	Mon,  7 Sep 2026 14:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788791977; cv=none; b=JuWx8TZT3NNKSHL3HTmjOjckWGjDPLzdCTU/3oFkPcbZfMr1zs2bUHnxjqlEY75qxbqypbND/HekrUgYOs2kSdneB2+D9NUtw8jj2digJYTC2CN+gNZaGG6zNld+3koe5Sf6hCXj9GMCW8VyUeFRDnCKkbn+8GWbm1zprODqCwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788791977; c=relaxed/simple;
	bh=/bz/aFQQ20nFyliaYCaAIcREn7Se1rhUXGzYfo0Ic0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YAz0nEaRQWZ9oBiBJG6/b2DJKXz9c9WzJ5rgaugIpa7mpF7TqpWf1FOtIKuRicPE9CfAfzMntPRD2HVF/mIf+3gMsSHMZA+uQFIUMSytyGw1Q4GC8xyzXAzZsyqOIio0QQK+QFNJwCKC/x40XetPdobQf1IkOhNC2mkUXMzdQM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jjM0/9i/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jjM0/9i/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0462B1F00A3F;
	Mon,  7 Sep 2026 14:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788791969;
	bh=DSub+hZOtRHGsN+2zPdK5QKBiPWxfufgnD+1IXXZLf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jjM0/9i/h6ry7glcyv8ofb+uVX+bNoBCwX0AxVPTg18WklFHwIgbrEzu+yMwxulh5
	 Quti9XGla5aKFuA+FAbD08h+uSRL5vkROkWhwqkH6t72UveXyLQd9fJPYISzoSV/s8
	 05Dfb58H9AHolNqNgYpgo++hrcr7172SIvfyv+FxDGhJgRXfQYnxUzi3rvKLlioMqv
	 FmdqVbNtIOyBv5AzcTuK17pZsRrlmKFPbCUmzuILqu9JALnYD4buGfAB6bfViJmdTR
	 UN4D+4TBDlEAuD4q1+CD+eNzhR9j7dlfdbtlxsSjI9ph2McTbWlf0nSJ0fx3eb8WYA
	 lH5loGiZu4Upw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6.y 3/4] cifs: SMB1 split: Separate out SMB1 decls into smb1proto.h
Date: Mon,  7 Sep 2026 10:39:22 -0400
Message-ID: <20260907143923.3586545-3-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260907143923.3586545-1-sashal@kernel.org>
References: <2026090352-renegade-sneeze-d3c6@gregkh>
 <20260907143923.3586545-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Howells <dhowells@redhat.com>

[ Upstream commit 645427b7a6c59e0074df29bf939aec2e9d6f2819 ]

Separate out SMB1 declarations scriptedly into smb1proto.h.  Script below:

	#!/usr/bin/perl -w
	use strict;
	unless (@ARGV) {
	    die "Usage: $0 <c_file1> [<c_file2> ...]\n";
	}

	# Data tracking
	my %funcs = ();		# Func name => { func prototype }
	my %headers = ();	# Header filename => { header content }
	my %c_files = ();	# C filename => { ordered func list, header pref }
	my %cmarkers = ();	# C filename marker => { header filename it's in }

	# Parse state
	my $pathname = "-";
	my $lineno = 0;

	sub error(@) {
	    print STDERR $pathname, ":", $lineno, ": ", @_, "\n";
	    exit(1);
	}

	sub pad($) {
	    # Reindent the function arguments to line the arguments up with the char
	    # after the opening bracket on the func argument list
	    my ($lines) = @_;
	    return $lines if ($#{$lines} <= 0);
	    my $has_empty = 0;
	    for (my $i = 0; $i <= $#{$lines}; $i++) {
		$lines->[$i] =~ s/^[ \t]+//;
		$has_empty = 1 if ($lines->[$i] eq "");
	    }

	    if ($has_empty) {
		my @clean = grep /.+/, @{$lines};
		$lines = \@clean;
	    }

	    my $indlen = index($lines->[0], "(");
	    return $lines if ($indlen < 0);
	    my $indent = "";
	    $indlen++;
	    $indent .= "\t" x ($indlen / 8);
	    $indent .= " " x ($indlen % 8);

	    my @padded = ();
	    my $acc = "";
	    my $len = -$indlen;
	    for (my $i = 0; $i <= $#{$lines}; $i++) {
		my $argument = $lines->[$i];
		my $arglen = length($argument);
		my $last = ($i == $#{$lines} ? 1 : 0);

		if ($i == 0 ||
		    $i == 1) {
		    $acc .= $argument;
		    $acc .= ";" if ($last);
		    $len += $arglen + $last;
		    next;
		}
		if (!$acc) {
		    $acc = $indent . $argument;
		    $acc .= ";" if ($last);
		    $len += $arglen + $last;
		    next;
		}
		if ($indlen + $len + 1 + $arglen + $last > 79) {
		    push @padded, $acc;
		    $acc = $indent . $argument;
		    $acc .= ";" if ($last);
		    $len = $arglen + $last;
		    next;
		}

		$acc .= " " . $argument;
		$acc .= ";" if ($last);
		$len += 1 + $arglen + $last;
	    }
	    push @padded, $acc if ($acc);
	    return \@padded;
	}

	sub earliest(@) {
	    my $ret = -1;
	    foreach (@_) {
		$ret = $_ if ($ret < 0 || ($_ >= 0 && $_ < $ret));
	    }
	    return $ret;
	}

	foreach my $file (@ARGV) {
	    # Open the file for reading.
	    next if $file =~ /trace[.]h$/;
	    next if $file =~ /smbdirect[.][ch]$/;
	    open my $fh, "<$file"
		or die "Could not open file '$file'";
	    $pathname = $file;
	    $lineno = 0;

	    my $filename;
	    my @file_content = ();
	    my @copy = ();

	    my $state = 0;
	    my $qual = "";
	    my $type = "";
	    my $funcname = "";
	    my @funcdef = ();
	    my $bracket = 0;
	    my $comment = 0;
	    my $smb1 = 0;
	    my $header = 0;
	    my $inline = 0;
	    my $file_marker = "";
	    my $config = "";
	    my $c_file = 0;

	    $filename = $pathname;
	    $filename =~ s!.*/!!;

	    if ($file =~ m!.h$!) {
		my %new_h_file = (
		    path    => $pathname,
		    fname   => $filename,
		    content => [],
		    );
		$header = \%new_h_file;
		$headers{$filename} = \%new_h_file;
	    } elsif ($file =~ m!.c$!) {
		my %new_c_file = (
		    path  => $pathname,
		    fname => $filename,
		    funcs => [],
		    );
		$c_file = \%new_c_file;
		$c_files{$filename} = \%new_c_file;
	    } else {
		warn("Ignoring unexpected file $file\n");
		next;
	    }

	    $smb1 = 1 if ($file =~ m!/smb1ops.c|/cifssmb.c|/cifstransport.c!);

	    foreach my $line (<$fh>) {
		$lineno++;
		chomp($line);
		push @copy, $line;
		if (!$line) {
		    # Blank line
		    push @file_content, @copy;
		    @copy = ();
		    next;
		}

		# Handle continuation or end of block comment.  Look for C file
		# prototype insertion point markers.
		if ($comment) {
		    if ($line =~ m![*]/!) {
			if ($comment == 2 && $file_marker) {
			    $cmarkers{$file_marker} = $file_marker;
			    push @copy, "#C_MARKER " . $file_marker;
			    $file_marker = 0;
			}
			$comment = 0;
		    } else {
			$comment++;
			if ($comment == 2 && $line =~ m! [*] ([a-z][a-z_0-9]*[.][c])$!) {
			    $file_marker = $1;
			    print("Found file marker ", $file_marker, " in ", $filename, "\n");
			}
		    }
		    push @file_content, @copy;
		    @copy = ();
		    next;
		}

		# Check cpp directives, particularly looking for SMB1 bits
		if ($line =~ /^[#]/) {
		    if ($header) {
			if ($line =~ /ifdef.*(CONFIG_[A-Z0-9_])/) {
			    error("multiconfig") if $config;
			    $config = $1;
			    $smb1++ if ($config eq "CONFIG_CIFS_ALLOW_INSECURE_LEGACY");
			} elsif ($line =~ /endif/) {
			    $smb1-- if ($config eq "CONFIG_CIFS_ALLOW_INSECURE_LEGACY");
			    $config = "";
			}
		    }
		    push @file_content, @copy;
		    @copy = ();
		    next;
		}

		# Exclude interference in finding func names and return types
		if ($line =~ /^[{]/ ||
		    $line =~ /##/ ||
		    $line =~ /^[_a-z0-9A-Z]+:$/ || # goto label
		    $line =~ /^do [{]/ ||
		    $line =~ m!^//!) {
		    push @file_content, @copy;
		    @copy = ();
		    next;
		}

		# Start of a block comment
		if ($line =~ m!^/[*]!) {
		    $comment = 1 unless ($line =~ m![*]/!);
		    push @file_content, @copy;
		    @copy = ();
		    next;
		}

		# End of a braced section, such as a function implementation
		if ($line =~ /^[}]/) {
			$type = "";
			$qual = "";
			$funcname = "";
			@funcdef = ();
			push @file_content, @copy;
			@copy = ();
			next;
		}

		if ($line =~ /^typedef/) {
		    $type = "";
		    $qual = "";
		    $funcname = "";
		    @funcdef = ();
		    push @file_content, @copy;
		    @copy = ();
		    next;
		}

		# Extract function qualifiers.  There may be multiple of these in more
		# or less any order.  Some of them cause the func to be skipped (e.g. inline).

		if ($line =~ /^(static|extern|inline|noinline|noinline_for_stack|__always_inline)\W/ ||
		    $line =~ /^(static|extern|inline|noinline|noinline_for_stack|__always_inline)$/) {
		    error("Unexpected qualifier '$1'") if ($state != 0);
		    while ($line =~ /^(static|extern|inline|noinline|noinline_for_stack|__always_inline)\W/ ||
			   $line =~ /^(static|extern|inline|noinline|noinline_for_stack|__always_inline)$/) {
			$qual .= " " if ($qual);
			$qual .= $1;
			$inline = 1 if ($1 eq "inline");
			$inline = 1 if ($1 eq "__always_inline");
			$line = substr($line, length($1));
			$line =~ s/^\s+//;
		    }
		}

		if ($state == 0) {
		    # Extract what we assume to be the return type
		    if ($line =~ /^\s/) {
			push @file_content, @copy;
			@copy = ();
			next;
		    }
		    while ($line =~ /^(unsigned|signed|bool|char|short|int|long|void|const|volatile|(struct|union|enum)\s+[_a-zA-Z][_a-zA-Z0-9]*|[*]|__init|__exit|__le16|__le32|__le64|__be16|__be32|__be64)/) {
			$type .= " " if $type;
			$type .= $1;
			$line = substr($line, length($1));
			$line =~ s/^\s+//;
		    }
		    if ($line =~ /^struct [{]/) {
			# Ignore structure definitions
			$type = "";
			$qual = "";
			$funcname = "";
			@funcdef = ();
			push @file_content, @copy;
			@copy = ();
			next;
		    }
		    if (index($line, "=") >= 0) {
			# Ignore assignments
			$type = "";
			$qual = "";
			$funcname = "";
			@funcdef = "";
			push @file_content, @copy;
			@copy = ();
			next;
		    }

		    # Try and extract a function's type and name
		    while ($line =~ /(^[_a-zA-Z][_a-zA-Z0-9]*)/) {
			my $name = $1;
			$line = substr($line, length($name));
			next if ($line =~ /^[{]/);
			$line =~ s/^\s+//;

			my $ch = substr($line, 0, 1);
			last if ($ch eq "[" || $ch eq ";"); # Global variables

			if ($ch eq "(") {
			    # Found the function name
			    $state = 1;
			    $line = substr($line, 1);
			    $funcname = $name;
			    my $tmp = $qual . $type . " " . $funcname . "(";
			    $tmp =~ s/[*] /*/;
			    push @funcdef, $tmp;
			    $bracket = 1;
			    last;
			}

			if ($type) {
			    last if (index($line, ";") >= 0 && index($line, "(") == -1);
			    error("Unexpected name '$name' after '$type'");
			}

			$type .= " " if $type;
			$type .= $name;
			if ($line =~ /^(\s*[*]+)/) {
			    my $ptr = $1;
			    $type .= $ptr;
			    $line = substr($line, length($ptr));
			}
		    }
		}

		# Try and extract a function's argument list
		my $from = 0;
		if ($state == 1) {
		    while (1) {
			my $o = index($line, "(", $from);
			my $c = index($line, ")", $from);
			my $m = index($line, ",", $from);

			my $b = earliest($o, $c, $m);
			if ($b < 0) {
			    push @funcdef, $line
				unless ($line eq "");
			    last;
			}
			my $ch = substr($line, $b, 1);

			# Push the arguments separately on to the list
			if ($ch eq ",") {
			    push @funcdef, substr($line, 0, $b + 1);
			    $line = substr($line, $b + 1);
			    $from = 0;
			} elsif ($ch eq "(") {
			    # Handle brackets in the argument list (e.g. function
			    # pointers)
			    $bracket++;
			    $from = $b + 1;
			} elsif ($ch eq ")") {
			    $bracket--;
			    if ($bracket == 0) {
				push @funcdef, substr($line, 0, $b + 1);
				$line = substr($line, $b + 1);
				$state = 2;
				last;
			    }
			    $from = $b + 1;
			}
		    }
		}

		if ($state == 2) {
		    $inline = 1 if ($qual =~ /inline/);
		    #print("QUAL $qual $type $funcname $inline ", $#funcdef, "\n");
		    if (!$header &&
			$qual !~ /static/ &&
			$funcname ne "__acquires" &&
			$funcname ne "__releases" &&
			$funcname ne "module_init" &&
			$funcname ne "module_exit" &&
			$funcname ne "module_param" &&
			$funcname ne "module_param_call" &&
			$funcname ne "PROC_FILE_DEFINE" &&
			$funcname !~ /MODULE_/ &&
			$funcname !~ /DEFINE_/) {

			# Okay, we appear to have a function implementation
			my $func;
			my $dup = 0;

			if (exists($funcs{$funcname})) {
			    $func = $funcs{$funcname};
			    if (exists $func->{body}) {
				print("dup $funcname\n");
				$dup = 1;
			    }
			} else {
			    my %new_func = (
				name => $funcname,
				cond => "",
				legacy => 0,
				);
			    $func = \%new_func;
			    $funcs{$funcname} = $func;
			    $func->{body} = pad(\@funcdef);
			}
			$func->{body} = pad(\@funcdef);
			$func->{legacy} = 1 if $smb1;

			if ($funcname eq "cifs_inval_name_dfs_link_error") {
			    $func->{cond} = "#ifdef CONFIG_CIFS_DFS_UPCALL";
			} elsif ($funcname eq "cifs_listxattr") {
			    $func->{cond} = "#ifdef CONFIG_CIFS_XATTR";
			}

			push @{$c_file->{funcs}}, $func
			    unless $dup;
		    } elsif (!$header || $inline) {
			# Ignore inline function implementations and other weirdies
			push @file_content, @copy;
		    } elsif ($header && !$inline) {
			push @file_content, "#FUNCPROTO " . $funcname;

			my $func;

			if (exists($funcs{$funcname})) {
			    $func = $funcs{$funcname};
			    $func->{lineno} = $lineno;
			    $func->{pathname} = $pathname;
			} else {
			    my %new_func = (
				name => $funcname,
				cond => "",
				lineno => $lineno,
				pathname => $pathname,
				legacy => 0,
				);
			    $func = \%new_func;
			    $funcs{$funcname} = $func;
			}

			$func->{legacy} = 1 if $smb1;
		    }

		    @funcdef = ();
		    $type = "";
		    $qual = "";
		    $funcname = "";
		    $inline = 0;
		    $state = 0;
		    @copy = ();
		}
		if ($line =~ /;/) {
		    $type = "";
		    $qual = "";
		    $funcname = "";
		    @funcdef = ();
		    $state = 0;
		    push @file_content, @copy;
		    @copy = ();
		}
	    }
	    close($fh);

	    if ($header) {
		$header->{content} = \@file_content;
	    }
	}

	sub write_header($)
	{
	    my ($header) = @_;
	    my $path = $header->{path};
	    my $legacy = 0;

	    $legacy = 1 if ($path =~ m!smb1proto[.]h!);

	    my @output = ();

	    foreach my $line (@{$header->{content}}) {
		if ($line =~ "^[#]C_MARKER (.*)") {
		    my $file_marker = $cmarkers{$1};
		    my $c_file = $c_files{$file_marker};
		    print("Found $line\n");
		    foreach my $func (@{$c_file->{funcs}}) {
			print("func ", $func->{name}, "\n");
			push @output, @{$func->{body}};
		    }
		    next;
		} elsif ($line =~ "^[#]FUNCPROTO ([_a-zA-Z0-9]+)") {
		    my $funcname = $1;
		    my $func = $funcs{$funcname};
		    if (!$func->{body}) {
			print($func->{pathname}, ":", $func->{lineno}, ": '", $funcname,
			      "' dead prototype\n");
			next;
		    }
		    if ($func->{legacy} == $legacy) {
			#push @output, $line;
			push @output, @{$func->{body}};
		    }
		} else {
		    push @output, $line;
		}
	    }

	    open my $fh, ">$path"
		or die "Could not open file '$path' for writing";
	    foreach my $f (@output) {
		print($fh $f, "\n") or die $path;
	    }
	    close($fh) or die $path;
	}

	foreach my $h (keys(%headers)) {
	    write_header($headers{$h});
	}

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Enzo Matsumiya <ematsumiya@suse.de>
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
cc: linux-kernel@vger.kernel.org
Acked-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Steve French <stfrench@microsoft.com>

[ sashal: Reduced backport -- upstream 645427b7a6c59 touches 3 file(s), this
  backport carries 1. Not backported here:
  fs/smb/client/cifsproto.h
  fs/smb/client/fscache.h
  fs/smb/client/smb1proto.h
  This note is generated from the file lists only; see the resolution record
  for the reasoning. ]

Stable-dep-of: b8e5dc4f95e5 ("smb: client: clear setuid/setgid bit on write with cifsacl/modefromsid/posix extensions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index cca480ab7e64b..158502136ecac 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -3162,6 +3162,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 	kgid_t gid = INVALID_GID;
 	struct inode *inode = d_inode(direntry);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	unsigned int sbflags = cifs_sb->mnt_cifs_flags;
 	struct cifsInodeInfo *cifsInode = CIFS_I(inode);
 	struct cifsFileInfo *wfile;
 	struct cifs_tcon *tcon;
@@ -3177,7 +3178,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 	cifs_dbg(FYI, "setattr on file %pd attrs->ia_valid 0x%x\n",
 		 direntry, attrs->ia_valid);
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_PERM)
+	if (sbflags & CIFS_MOUNT_NO_PERM)
 		attrs->ia_valid |= ATTR_FORCE;
 
 	rc = setattr_prepare(&nop_mnt_idmap, direntry, attrs);
-- 
2.53.0

