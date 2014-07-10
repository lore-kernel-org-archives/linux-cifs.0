From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: connecting to windows server with SMB2
Date: Thu, 10 Jul 2014 08:58:30 -0500
Message-ID: <CADT32eJXnapxz31nOXqhX9kRsjxFxY=UT-gfLYfCL6905-TP7Q@mail.gmail.com>
References: <27156595.1471091404988006041.JavaMail.weblogic@epv6ml04>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: a.sangwan-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <27156595.1471091404988006041.JavaMail.weblogic@epv6ml04>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

In order to sec=ntlmv2 succeed, you will need this patch on the Windows 7 box.
http://support.microsoft.com/kb/957441/en-us

For smb2 (vers=2.0), sec=ntlmssp (which is the default) should succeed against
a Windows 7 box.

Would it be possible to attach a wireshark trace of the exchange?



On Thu, Jul 10, 2014 at 5:26 AM, Ashish Sangwan <a.sangwan-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org> wrote:
> I am using kernel version 3.8.13 and windows 7.
>
> The below command works successfully:
> Linux#> mount -t cifs //107.109.224.147/sharefolder /mnt -o user=a.sangwan -o pass=xxxx -o vers=1.0 -o sec=ntlm
>
> Other than 1.0, all are fail:
> Linux#> mount -t cifs //107.109.224.147/sharefolder /mnt -o user=a.sangwan -o pass=xxxx -o vers=2.0 -o sec=ntlm
> [ 0][   64.276000] Status code returned 0xc000006d STATUS_LOGON_FAILURE
> [ 0][   64.284000] CIFS VFS: Send error in SessSetup = -13
>
> Tried with sec=ntlmv2/none/lanman/krb5, none of them worked.
> Help please!!
