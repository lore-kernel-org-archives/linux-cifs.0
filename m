From: Hadrien Grasland <grasland-dJj/bURytuEtnUBFBimtzg@public.gmane.org>
Subject: Re: [PATCH] CIFS: do not send invalid input buffer on QUERY_INFO
 requests
Date: Wed, 18 Oct 2017 22:20:25 +0200
Message-ID: <2cc607c4-36cf-caaf-9deb-3ec25287ded9@lal.in2p3.fr>
References: <mpsa80ruowd.fsf@aaptelpc.suse.de>
 <20171017124717.25955-1-aaptel@suse.com>
 <f87e7391-b2f0-feaf-3489-686d0368fe64@lal.in2p3.fr>
 <mpspo9ktsr5.fsf@aaptelpc.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: =?UTF-8?Q?Aur=c3=a9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>,
        linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <mpspo9ktsr5.fsf-zpEvHKhluMwYitT5tn2FcQ@public.gmane.org>
Content-Language: fr
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Le 18/10/2017 à 16:50, Aurélien Aptel a écrit :
> Hadrien Grasland <grasland-dJj/bURytuEtnUBFBimtzg@public.gmane.org> writes:
>> Just tried out this patch, and the CIFS module does indeed produce
>> well-formed GetInfo requests now (according to Wireshark's definition at
>> least, didn't check myself).
>>
>> However, the server will still reject the request with a
>> STATUS_NOT_SUPPORTED error, suggesting that Steve's interpretation was
>> the right one: this is likely a server-side bug.
> Yes. As Steve suggested as a workaround, we could try to use a less
> detailed information level if FullInfo fails. Is it worth doing for a
> single old NetApp server?

If it's only me that's having the issue, I would say don't bother. The 
same system issue that prevents my sysadmin colleagues from updating to 
a NetApp software version where the bug is fixed also prevents them from 
disabling SMBv1 support, and sticking with SMBv1 for now is fine by me.


> As for the offset and extra byte in QUERY_INFO I guess having the length
> set to 0 makes it ok... I've sent a couple of patches to Wireshark to
> fix the packet parsing. It now accepts the empty filename in CREATE (no
> more "[unknown]"), which enables the proper parsing of the unknown
> field.
Thanks for looking into this!
Hadrien
