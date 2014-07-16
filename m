From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Re: connecting to windows server with SMB2
Date: Tue, 15 Jul 2014 23:09:41 -0500
Message-ID: <CADT32eLaBieB6driDX7OAX8GBe38BSrNgW6KRWKk6rboZ5V4OA@mail.gmail.com>
References: <1613860881.159901405483680198.JavaMail.weblogic@epmlwas01d>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
To: a.sangwan-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1613860881.159901405483680198.JavaMail.weblogic@epmlwas01d>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Can you change it to 3 (or higher upto 5), I think then ntlmv2 will
start working.



On Tue, Jul 15, 2014 at 11:08 PM, Ashish Sangwan <a.sangwan-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org> wrote:
> Hi Shirish,
>
> LMCompatibilityLevel is set at 2
>
> Regards,
> Ashish
> ------- Original Message -------
> Sender : Shirish Pargaonkar<shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Date : Jul 12, 2014 02:35 (GMT+05:30)
> Title : Re: connecting to windows server with SMB2
>
> Can you check the value of the registry setting on the server?
>
> HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\LSA\LMCompatibilityLevel
>
> On Thu, Jul 10, 2014 at 5:26 AM, Ashish Sangwan wrote:
>> I am using kernel version 3.8.13 and windows 7.
>>
>> The below command works successfully:
>> Linux#> mount -t cifs //107.109.224.147/sharefolder /mnt -o user=a.sangwan -o pass=xxxx -o vers=1.0 -o sec=ntlm
>>
>> Other than 1.0, all are fail:
>> Linux#> mount -t cifs //107.109.224.147/sharefolder /mnt -o user=a.sangwan -o pass=xxxx -o vers=2.0 -o sec=ntlm
>> [ 0][   64.276000] Status code returned 0xc000006d STATUS_LOGON_FAILURE
>> [ 0][   64.284000] CIFS VFS: Send error in SessSetup = -13
>>
>> Tried with sec=ntlmv2/none/lanman/krb5, none of them worked.
>> Help please!!
