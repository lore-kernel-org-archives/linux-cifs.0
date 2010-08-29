From: Suresh Jayaraman <sjayaraman@suse.de>
Subject: Re: smbd blocks for 120 secs and then hangs in D state
Date: Sun, 29 Aug 2010 23:30:02 +0530
Message-ID: <4C7AA022.3000906@suse.de>
References: <AANLkTik=70UfQue+WL=NWLtni7NiajZiXqUZ-4xg2rPs@mail.gmail.com>	<20100823071702.2437b523@tlielax.poochiereds.net>
	<AANLkTi=+FYRzX=yy67tOF+pmNnW8Rr3zcRK3pnOS3ts6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, Jeff Layton <jlayton@redhat.com>
To: Vijai Baskar <cristalmaze@gmail.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <AANLkTi=+FYRzX=yy67tOF+pmNnW8Rr3zcRK3pnOS3ts6@mail.gmail.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

On 08/28/2010 09:48 AM, Vijai Baskar wrote:
> The server and the client are different.. Server is the board and
> client is my PC.
>=20

>=20
> On Mon, Aug 23, 2010 at 4:47 PM, Jeff Layton <jlayton@redhat.com> wrote=
:
>> On Mon, 23 Aug 2010 10:40:34 +0530
>> Vijai Baskar <cristalmaze@gmail.com> wrote:
>>
>>> Hi all,
>>>
>>> I am running a samba copy of a 4GB file from my local hard disk to a
>>> remote hard disk and then find md5sum of the same file in the remote
>>> hard disk through samba read. I do the following to accomplish this:
>>>
>>> 1. mount -t cifs //ip-addr/data /mnt
>>> 2. cp /home/4g /mnt
>>> 3. md5sum /mnt/4g
>>>
>>> After a few iterations of the above operation I get the following
>>> warning on the board:
>>>
>>> echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messa=
ge.
>>> [ 6122.450000] smbd =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD=
D c0204908 =EF=BF=BD =EF=BF=BD 0 =EF=BF=BD9712 =EF=BF=BD =EF=BF=BD372 0x0=
0000000
>>> [ 6122.480000] [<c0204908>] (schedule+0x2dc/0x328) from [<c0204980>]
>>> (io_schedule+0x2c/0x48)
>>> [ 6122.500000] [<c0204980>] (io_schedule+0x2c/0x48) from [<c0072064>]
>>> (sync_page+0x44/0x50)
>>> [ 6122.530000] [<c0072064>] (sync_page+0x44/0x50) from [<c0204dd4>]
>>> (__wait_on_bit_lock+0x5c/0xa8)
>>> [ 6122.560000] [<c0204dd4>] (__wait_on_bit_lock+0x5c/0xa8) from
>>> [<c0071ff0>] (__lock_page+0x88/0xa0)
>>> [ 6122.590000] [<c0071ff0>] (__lock_page+0x88/0xa0) from [<c007b530>]
>>> (truncate_inode_pages_range+0x2e4/0x38c)
>>> [ 6122.620000] [<c007b530>] (truncate_inode_pages_range+0x2e4/0x38c)
>>> from [<c007b5f0>] (truncate_inode_pages+0x18/0x20)
>>> [ 6122.640000] [<c007b5f0>] (truncate_inode_pages+0x18/0x20) from
>>> [<c0085acc>] (vmtruncate+0xe4/0x14c)
>>> [ 6122.670000] [<c0085acc>] (vmtruncate+0xe4/0x14c) from [<c00a43a8>]
>>> (inode_setattr+0x48/0x148)
>>> [ 6122.700000] [<c00a43a8>] (inode_setattr+0x48/0x148) from
>>> [<c00a4630>] (notify_change+0x188/0x1dc)
>>> [ 6122.730000] [<c00a4630>] (notify_change+0x188/0x1dc) from
>>> [<c0091440>] (do_truncate+0x6c/0x88)
>>> [ 6122.760000] [<c0091440>] (do_truncate+0x6c/0x88) from [<c00915c0>]
>>> (do_sys_ftruncate+0x164/0x170)
>>> [ 6122.800000] [<c00915c0>] (do_sys_ftruncate+0x164/0x170) from
>>> [<c00915e0>] (sys_ftruncate64+0x14/0x1c)
>>> [ 6122.830000] [<c00915e0>] (sys_ftruncate64+0x14/0x1c) from
>>> [<c0027fa0>] (ret_fast_syscall+0x0/0x2c)
>>>
>>> After this samba daemon hangs in the D state. I changed the values of
>>> /proc/sys/vm/dirty_writeback_centisecs to 250 (default 500) and
>>> /proc/sys/vm/dirty_expire_centisecs to 1000 (default 3000). But this
>>> only delays the problem. ps-ax shows smbd in D state. This problem
>>> seems to occur only during samba read.
>>>
>>> Can someone please provide me a solution for the above problem?
>>>
>>> regards,
>>> vijai
>>>
>>
>> (cc'ing linux-fsdevel and samba-technical as this problem is probably
>> better reported there)
>>
>> The stack trace above is for smbd, so I doubt this has much to do with
>> cifs per-se. Just to make sure though -- are the server and client the
>> same host? Hint: if so, that configuration is prone to deadlock under
>> heavy I/O.
>>
>> When reporting kernel bugs, it's also a good idea to mention the kerne=
l
>> version. It might also be helpful to know what the underlying
>> filesystem is that's being served out.

Care to provide the kernel version and filesystem info requested above?

>>
>> It looks like the process is hung trying to lock a page. Most likely
>> that means that something else is holding that lock and not releasing
>> it for some reason. Debugging this will probably mean figuring out
>> what's holding that lock and why it's not releasing it.
>>

Do you have a reliable way of reproducing the problem?


Thanks,

--=20
Suresh Jayaraman
