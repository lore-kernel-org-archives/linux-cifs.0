From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 0/3] cifs.upcall: attempt to use AD-style service principals
Date: Sun, 13 Nov 2011 20:17:25 -0500
Message-ID: <1321233448-13548-1-git-send-email-jlayton@samba.org>
Cc: idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We've had a request recently to allow cifs.upcall to use AD-style
service principals. While trying to nail down what they need, I asked
Simo his opinion on how best to pick a service principal for a given
hostname. His suggestion was:

	INPUT: fooo
	TRY in order:
  		FOOO$@REALM
		cifs/fooo.<guessed domain ?>@REALM
  		host/fooo.<guessed domain ?>@REALM

	INPUT: bar.example.com
	TRY in order:
		cifs/bar.example.com@REALM
		BAR$@REALM
		host/bar.example.com@REALM

This patchset attempts to embody that logic.

Suggestions welcome. Those reviewing it, please pay particular attention
to the scheme for guessing a domain name. I want to make certain that
we're not opening up any security holes with that scheme.

Jeff Layton (3):
  cifs.upcall: move to an on-stack princ buffer
  cifs.upcall: move to Simo's suggested algorithm for picking a
    principal
  cifs.upcall: try and guess the domain name on unqualified names

 cifs.upcall.c |  143 ++++++++++++++++++++++++++++++++++++++++++++++----------
 1 files changed, 117 insertions(+), 26 deletions(-)

-- 
1.7.6.4
