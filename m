From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: SMB3: Add xattr support to SMB3 and a bug fix
Date: Thu, 7 Sep 2017 18:13:39 -0500
Message-ID: <CAH2r5mvVJVjFj_uMtxNkteQC=+njXq37o3RNDuJONtaXNfvpeg@mail.gmail.com>
References: <CAH2r5muU8xpsW6WXkMkf_vY1r9u7_ZEsp4fEJykz=nsH=BfGpw@mail.gmail.com>
 <CA+55aFwRv9X4L9kse4ODq=jBzUVqEnHdhi-2tesUpaZW6GbZMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFwRv9X4L9kse4ODq=jBzUVqEnHdhi-2tesUpaZW6GbZMg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

ok - with git request pull I end up with the branch name rather than
the  equivalent signed tag in the pull request - so will fix these up
manually to not show the branch but rather than tag

On Thu, Sep 7, 2017 at 6:09 PM, Linus Torvalds
<torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> On Thu, Sep 7, 2017 at 2:45 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>>   git://git.samba.org/sfrench/cifs-2.6.git for-next
> ...
>> Signed tag is 4.14-smb3-xattr-enable
>
> So this is now the third time that I have done a
>
>    "git pull git://git.samba.org/sfrench/cifs-2.6.git for-next"
>
> and then noticed belatedly the note about how the signed tag is
> actually elsewhere, and had to reset and redo the pull.
>
> And I wonder how many times I _didn't_ notice that note? Maybe I've
> caught them all, but it wouldn't surprise me at all if there were tons
> of cases where I didn't.
>
> So can you please just tell me what to pull, rather than first put
> that decoy wrong address in, and then adding a note about what the
> right one is?
>
> Please. No more decoys.
>
> Just tell me to pull
>
>    git://git.samba.org/sfrench/cifs-2.6.git 4.14-smb3-xattr-enable
>
> without any mind games. Ok?
>
>             Linus



-- 
Thanks,

Steve
