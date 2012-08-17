From: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Samba] Mount CIFS with multiuser option
Date: Fri, 17 Aug 2012 11:24:59 +0200
Message-ID: <CANXojcx7VS6mKQHoKY74jzn47TTKXiWamEvW-=1fCQHLpAP31Q@mail.gmail.com>
References: <OF5F429226.78706E8D-ON86257A5C.007118E9-86257A5C.00718CE4@TMRIUSA.COM>
	<CADT32eLsYB2rMfuYgyQHPvP1PmZgDJ-01=cJnakEhwJH2a2YxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Bastien Desalle <BDesalle-EIlpL8JyKVZBDgjK7y7TUQ@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eLsYB2rMfuYgyQHPvP1PmZgDJ-01=cJnakEhwJH2a2YxA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Have you tried a newer version of cifs-utils??


2012/8/16 Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> On Thu, Aug 16, 2012 at 3:40 PM, Bastien Desalle <BDesalle-EIlpL8JyKVZBDgjK7y7TUQ@public.gmane.org> wrote:
>> Hi,
>>
>> Overview: Running redhat 6.3 kernel 2.6.32-279.
>>               cifs-utils : 4.8.1-10
>>
>> server is connected to Active Directory and working fine. Users from AD can
>> log in the server and have their /home created if it is the first time.
>> and then when I do a Klist i have a ticket.
>>
>>     Default principal: test-yHMt7BE/qW2uvtTkCOosKA@public.gmane.org
>>
>>     Valid starting     Expires            Service principal
>>     08/16/12 14:34:27  08/17/12 00:34:28  krbtgt/TMRIUSA.COM-yHMt7BE/qW2uvtTkCOosKA@public.gmane.org
>>             renew until 08/23/12 14:34:27
>>
>> then my goal is to mount at boot time. windows share that then will be
>> available to all the users connected to the linux server. But i am having
>> hard time doing it. because i encounter the following problems.
>>
>> 1) i am unable to mount the windows share without using a user and password
>> from the AD even if the share does not required a password to be mounted
>> because accessible to everyone.
>>     //server/drive  /media/M  cifs  rw,exec._netdev,auto  0  0
>>
>> 2) bypassing this problem by using a test user i am able to mount it.
>>     //server/drive  /media/M  cifs
>> user=test,password=test,rw,exec._netdev,auto  0  0
>>
>> at this point i tried to use the multiuser option and sec=krb5 i have the
>> following error.
>>     mount error(126): Required key not available
>>
>> which i don't understand because klist is telling me that i have a ticket.
>
> I do not think this is the kerberos ticket complain, it is about the
> keys in the kernel keyring that are missing/not_registered.
>
>>
>> So here is where I am stuck and after days looking on google for help i am
>> resigned to ask fo help.
>> Thanks in advance for your help
>> Much appreciated,
>>
>>
>>
>>
>> -----
>> Bastien Desalle
>> --
>> View this message in context: http://samba.2283325.n4.nabble.com/Mount-CIFS-with-multiuser-option-tp4635839.html
>> Sent from the Samba - General mailing list archive at Nabble.com.
>>
>> ______________________________________________________________________
>> This email has been scanned by the Symantec Email Security.cloud service.
>> For more information please visit http://www.symanteccloud.com
>> ______________________________________________________________________
>> --
>> To unsubscribe from this list go to the following URL and read the
>> instructions:  https://lists.samba.org/mailman/options/samba
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
