From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/2 v2 ] Revamp SMB2 authentication code
Date: Fri,  7 Oct 2016 19:11:20 +0100
Message-ID: <1475863882-7223-1-git-send-email-sprabhu@redhat.com>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Revamp the authentication code for SMB2 to bring it in line with the code for
SMB1 authentication.

This also fixes a double free issue caused when we hit an error generating a
ntlmssp blob. One way to hit this is to enable FIPS mode which prevents the
module from using md5 for NTLMSSP authentication.

V2: Fix conflicts due to new code added to the for-next tree.

Sachin Prabhu (2):
  SMB2: Separate Kerberos authentication from SMB2_sess_setup
  SMB2: Seperate RawNTLMSSP authentication from SMB2_sess_setup

 fs/cifs/smb2pdu.c | 561 ++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 354 insertions(+), 207 deletions(-)

-- 
2.7.4
