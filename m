From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/2] Revamp SMB2 authentication code
Date: Thu, 22 Sep 2016 15:04:52 +0100
Message-ID: <1474553094-8884-1-git-send-email-sprabhu@redhat.com>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Revamp the authentication code for SMB2 to bring it in line with the code for
SMB1 authentication.

This also fixes a double free issue caused when we hit an error generating a
ntlmssp blob. One way to hit this is to enable FIPS mode which prevents the
module from using md5 for NTLMSSP authentication.

Sachin Prabhu (2):
  SMB2: Separate Kerberos authentication from SMB2_sess_setup
  SMB2: Seperate RawNTLMSSP authentication from SMB2_sess_setup

 fs/cifs/smb2pdu.c | 557 ++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 352 insertions(+), 205 deletions(-)

-- 
2.7.4
