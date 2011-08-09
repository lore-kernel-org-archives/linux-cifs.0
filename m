From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Switching to ntlmv2 in NTLMSSP default
Date: Tue, 9 Aug 2011 10:32:19 -0500
Message-ID: <CAH2r5muyPUKyqwbcv+8_0K01Ju=n63e-yeWSyVO2GWau=HX4Aw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Based on the data below, looks like we can safely default to ntlmv2 in
raw NTLMSSP for anything beyond NT4 SP3.  Other than legacy servers
(LANMAN), anyone aware of servers which will not accept this?

"Windows accepts raw NTLM NEGOTIATE messages that are not embedded in
  [RFC2743] InitialContextTokens in the SecurityBlob of an
  SMB_COM_SESSION_SETUP_ANDX request packet. This was introduced in
  the NTLMv2 implementation of Windows NT 4 Service Pack 4.  Windows
  servers do not accept NTLM messages that are properly contained
  inside a GSS InitialContextToken.  The server responds with
  STATUS_INVALID_PARAMETER.
...
  GSSAPI/SPNEGO support for Kerberos and NTLMSSP was introduced in
  Windows 2000. "

-- 
Thanks,

Steve
