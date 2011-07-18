From: Anatoli Tubman <anatolit-NvVUnrFE32e8rjiVs5Nzzw@public.gmane.org>
Subject: Long domain names in authentication
Date: Mon, 18 Jul 2011 11:29:10 +0300
Message-ID: <7F9A6D26EB51614FBF9F81C0DA4CFEC802281F269ED3@il-ex01.ad.checkpoint.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello there. Please excuse me if this was discussed before. I could
only find some mentions of the problem here and there, but not analysis
or workarounds.

There's a slight (or perhaps huge) problem with the CIFS in-kernel client
and/or the mount.cifs command. In one sentence: long AD domain names do not work
when authenticating against Windows servers. The detailed description is below.

I have a bog-standard Windows Active Directory with one domain configured
at my workplace. The domain name shall be "mydomain.example.com", and I'm
"someuser".

The following two commands do work:

    (1a) mount.cifs //server/share /dir -o user=someuser,dom=mydomain
    (1b) mount.cifs //server/share /dir -o user=mydomain\\someuser

As far as I can tell they do exactly the same thing, so iin what follows
I will refer only to the first variant.

The following command does **not** work:

    (2) mount.cifs //server/share /dir \
            -o user=someuser,dom=mydomain.example.com

It results in the (in)famous "mount error(5): Input/output error" message.

A command using the UPN notation does work:

    (3) mount.cifs //server/share /dir -o \
           user=someuser-3Q2Tfjf0mexuYUHNOcvv81aTQe2KTcn/@public.gmane.org

Here's my attempt to analyze the situation.

There's a field in the SMB protocol called PrimaryDomain, used in the
SMB_COM_SESSION_SETUP_ANDX messages (both request and response). The
CIFS client uses this field to transmit the "dom" parameter to the
server. Here lies the problem, signs of which are as follows:

 1) A Windows XP client which is not a member of mydomain leaves this
    field blank when supplied with a full someuser\mydomain.example.com
    username.

 2) The file server uses the PrimaryDomain field of the response
    to sent the string "MYDOMAIN" (not mydomain.example.com) back to
    the client.

 3) If I try to use "dom=" parameter to send any string longer than
    15 characters, I get the "mount error (5): Input/output error" message.

All these signs are hinting that Windows servers expect PrimaryDomain to
be a NetBIOS domain name, not an AD domain name.

The (3) command works because the CIFS client does not understand the
UPN notation and and does not send anything in the PrimaryDoman field,
thus avoiding the problem.

The current official protocol specification doesn't mention any of
this. It simply says

   PrimaryDomain (variable): A string representing the desired
   authentication domain. [... Unicode stuff snipped ]

(see http://msdn.microsoft.com/en-us/library/ee442101%28v=PROT.13%29.aspx)

Samba implements the latest official protocol to the letter. It accepts
the full long AD domain name in the PrimaryDomain field, and does not
understand the UPN notation. This means that (2) works with Samba servers
and (3) does not, just the opposite of Windows servers.

Best regards

-- 
Anatoli Tubman 
MAB Group 
anatolit-NvVUnrFE32e8rjiVs5Nzzw@public.gmane.org +972.3.611.5203
Check Point Software Technologies www.checkpoint.com
