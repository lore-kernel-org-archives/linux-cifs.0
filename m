From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH 4.13 28/43] SMB3: Validate negotiate request must always
 be signed
Date: Tue, 27 Feb 2018 11:56:41 -0600
Message-ID: <CAH2r5mt91WGHDk-+LP4EBTEfAOmrY2k6_X7KKjc0D+LcDCfxRw@mail.gmail.com>
References: <20171031095530.520746935@linuxfoundation.org> <20171031095531.633196173@linuxfoundation.org>
 <97340c9a-0ea2-0d3d-cf26-58c799d76cae@mageia.org> <20171101151803.GB31285@kroah.com>
 <4ba67095-4075-688f-d3fb-157847aee4d9@csail.mit.edu> <28ffc363-5140-5685-d288-6e3dc07c6369@csail.mit.edu>
 <20180227085428.GA16879@kroah.com> <b20cbd94-ce9b-cb2c-dc95-a6821376823f@csail.mit.edu>
 <20180227124050.GB31888@kroah.com> <6bca5a97-f581-86b8-12ad-77147619d519@csail.mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Backlund <tmb@mageia.org>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Pavel Shilovskiy <pshilov@microsoft.com>,
        CIFS <linux-cifs@vger.kernel.org>
To: "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <6bca5a97-f581-86b8-12ad-77147619d519@csail.mit.edu>
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

This shouldn't be too hard to figure out if willing to backport a
slightly larger set of fixes to the older stable, but I don't have a
system running 4.9 stable.

Is this the correct stable tree branch?
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git/log/?h=linux-4.9.y

On Tue, Feb 27, 2018 at 11:45 AM, Srivatsa S. Bhat
<srivatsa@csail.mit.edu> wrote:
> On 2/27/18 4:40 AM, Greg Kroah-Hartman wrote:
>> On Tue, Feb 27, 2018 at 01:22:31AM -0800, Srivatsa S. Bhat wrote:
>>> On 2/27/18 12:54 AM, Greg Kroah-Hartman wrote:
>>>> On Mon, Feb 26, 2018 at 07:44:28PM -0800, Srivatsa S. Bhat wrote:
>>>>> On 1/3/18 6:15 PM, Srivatsa S. Bhat wrote:
>>>>>> On 11/1/17 8:18 AM, Greg Kroah-Hartman wrote:
>>>>>>> On Tue, Oct 31, 2017 at 03:02:11PM +0200, Thomas Backlund wrote:
>>>>>>>> Den 31.10.2017 kl. 11:55, skrev Greg Kroah-Hartman:
>>>>>>>>> 4.13-stable review patch.  If anyone has any objections, please let me know.
>>>>>>>>>
>>>>>>>>> ------------------
>>>>>>>>>
>>>>>>>>> From: Steve French <smfrench@gmail.com>
>>>>>>>>>
>>>>>>>>> commit 4587eee04e2ac7ac3ac9fa2bc164fb6e548f99cd upstream.
>>>>>>>>>
>>>>>>>>> According to MS-SMB2 3.2.55 validate_negotiate request must
>>>>>>>>> always be signed. Some Windows can fail the request if you send it unsigned
>>>>>>>>>
>>>>>>>>> See kernel bugzilla bug 197311
>>>>>>>>>
>>>>>>>>> Acked-by: Ronnie Sahlberg <lsahlber.redhat.com>
>>>>>>>>> Signed-off-by: Steve French <smfrench@gmail.com>
>>>>>>>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>>>>>>>
>>>>>>>>> ---
>>>>>>>>>   fs/cifs/smb2pdu.c |    3 +++
>>>>>>>>>   1 file changed, 3 insertions(+)
>>>>>>>>>
>>>>>>>>> --- a/fs/cifs/smb2pdu.c
>>>>>>>>> +++ b/fs/cifs/smb2pdu.c
>>>>>>>>> @@ -1963,6 +1963,9 @@ SMB2_ioctl(const unsigned int xid, struc
>>>>>>>>>        } else
>>>>>>>>>                iov[0].iov_len = get_rfc1002_length(req) + 4;
>>>>>>>>> +      /* validate negotiate request must be signed - see MS-SMB2 3.2.5.5 */
>>>>>>>>> +      if (opcode == FSCTL_VALIDATE_NEGOTIATE_INFO)
>>>>>>>>> +              req->hdr.sync_hdr.Flags |= SMB2_FLAGS_SIGNED;
>>>>>>>>>        rc = SendReceive2(xid, ses, iov, n_iov, &resp_buftype, flags, &rsp_iov);
>>>>>>>>>        cifs_small_buf_release(req);
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>
>>>>>>>> This one needs to be backported to all stable kernels as the commit that
>>>>>>>> introduced the regression:
>>>>>>>> '
>>>>>>>> 0603c96f3af50e2f9299fa410c224ab1d465e0f9
>>>>>>>> SMB: Validate negotiate (to protect against downgrade) even if signing off
>>>>>>>>
>>>>>>>> is backported in stable trees as of: 4.9.53, 4.4.90, 3.18.73
>>>>>>>
>>>>>>> Oh wait, it breaks the builds on older kernels, that's why I didn't
>>>>>>> apply it :)
>>>>>>>
>>>>>>> Can you provide me with a working backport?
>>>>>>>
>>>>>>
>>>>>> Hi Steve,
>>>>>>
>>>>>> Is there a version of this fix available for stable kernels?
>>>>>>
>>>>>
>>>>> Hi Greg,
>>>>>
>>>>> Mounting SMB3 shares continues to fail for me on 4.4.118 and 4.9.84
>>>>> due to the issues that I have described in detail on this mail thread.
>>>>>
>>>>> Since there is no apparent fix for this bug on stable kernels, could
>>>>> you please consider reverting the original commit that caused this
>>>>> regression?
>>>>>
>>>>> That commit was intended to enhance security, which is probably why it
>>>>> was backported to stable kernels in the first place; but instead it
>>>>> ends up breaking basic functionality itself (mounting). So in the
>>>>> absence of a proper fix, I don't see much of an option but to revert
>>>>> that commit.
>>>>>
>>>>> So, please consider reverting the following:
>>>>>
>>>>> commit 02ef29f9cbb616bf419 "SMB: Validate negotiate (to protect
>>>>> against downgrade) even if signing off" on 4.4.118
>>>>>
>>>>> commit 0e1b85a41a25ac888fb "SMB: Validate negotiate (to protect
>>>>> against downgrade) even if signing off" on 4.9.84
>>>>>
>>>>> They correspond to commit 0603c96f3af50e2f9299fa410c224ab1d465e0f9
>>>>> upstream. Both these patches should revert cleanly.
>>>>
>>>> Do you still have this same problem on 4.14 and 4.15?  If so, the issue
>>>> needs to get fixed there, not papered-over by reverting these old
>>>> changes, as you will hit the issue again in the future when you update
>>>> to a newer kernel version.
>>>>
>>>
>>> 4.14 and 4.15 work great! (I had mentioned this is in my original bug
>>> report but forgot to summarize it here, sorry).
>>
>>
>> Then what is the bugfix that should be applied here in order to keep
>> things working with these patches applied?
>>
>
> That would be the one mentioned in the subject line of this thread :)
> However, a working backport of that fix is not available for 4.4 and
> 4.9, hence the trouble.
>
> It looks like we are reconstructing elements of this email thread all
> over again, so let me quickly summarize the status so far:
>
> In 4.14/4.15/mainline,
> - commit 0603c96f3af50e2f9 (SMB: Validate negotiate (to protect against
>   downgrade) even if signing off) caused mount regression with SMB v3.
>
> - commit 4587eee04e2ac7ac3 (SMB3: Validate negotiate request must
>   always be signed) fixed the issue.
>
> - [ There was a lot of code churn in the CIFS/SMB codebase between
>     these two commits in mainline. ]
>
> In this email thread, you backported the fix to stable 4.13. Thomas
> noticed that the problematic commit had also made it to stable series
> such as 4.4 and 4.9, and requested a backport of the fix to those
> trees as well. However, a straight-forward backport of the fix to 4.4
> and 4.9 breaks the build, so no fix was available for those kernels.
>
> I investigated this and tried to produce a working backport of the fix
> to 4.4 and 4.9, but didn't succeed, despite trying several variations
> as well as suggestions from Aurelien [1][2]. So, given that there is
> still no known fix for the mount regression on 4.4 and 4.9 stable
> series at this point, I decided to request a revert of the problematic
> commit that caused the regression in those kernels.
>
> [1]. https://lkml.org/lkml/2018/1/3/892
> [2]. https://lkml.org/lkml/2018/1/29/1009
>
> Regards,
> Srivatsa



-- 
Thanks,

Steve
